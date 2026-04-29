import 'package:sqflite/sqflite.dart';

import '../dao/brewing_dao.dart';
import '../dao/flavor_profile_dao.dart';
import '../dao/session_dao.dart';
import '../database_helper.dart';
import '../models/brewing.dart';
import '../models/enums.dart';
import '../models/flavor_profile.dart';
import '../models/session.dart';

/// Geschäftslogik rund um Sessions:
/// fasst Session + BrewingParameters-Snapshot + FlavorProfile + Infusions
/// zusammen.
class SessionRepository {
  final DatabaseHelper _helper;
  final SessionDao _sessionDao;
  final BrewingDao _brewingDao;
  final FlavorProfileDao _profileDao;

  SessionRepository({
    required DatabaseHelper helper,
    required SessionDao sessionDao,
    required BrewingDao brewingDao,
    required FlavorProfileDao profileDao,
  })  : _helper = helper,
        _sessionDao = sessionDao,
        _brewingDao = brewingDao,
        _profileDao = profileDao;

  // ===================================================================
  // Reads
  // ===================================================================

  Future<List<Session>> getAll({
    int? teaId,
    SessionStatus? status,
    SessionType? type,
    int limit = 200,
    int offset = 0,
  }) async {
    final db = await _helper.database;
    return _sessionDao.getAll(
      db,
      teaId: teaId,
      status: status,
      type: type,
      limit: limit,
      offset: offset,
    );
  }

  Future<Session?> getById(int id) async {
    final db = await _helper.database;
    return _sessionDao.getById(db, id);
  }

  Future<SessionWithDetails?> getWithDetails(int id) async {
    final db = await _helper.database;
    final session = await _sessionDao.getById(db, id);
    if (session == null) return null;

    BrewingParameters? params;
    var steps = const <BrewingStep>[];
    var additives = const <BrewingAdditive>[];
    if (session.brewingParametersId != null) {
      params =
          await _brewingDao.getParameters(db, session.brewingParametersId!);
      steps = await _brewingDao.getStepsForParameters(
          db, session.brewingParametersId!);
      additives = await _brewingDao.getAdditivesForParameters(
          db, session.brewingParametersId!);
    }

    FlavorProfile? profile;
    var aromaTags = const <FlavorProfileAromaTag>[];
    if (session.flavorProfileId != null) {
      profile = await _profileDao.getById(db, session.flavorProfileId!);
      aromaTags = await _profileDao.getAromaTagsForProfile(
          db, session.flavorProfileId!);
    }

    final infusionRows = await _sessionDao.getInfusionsForSession(db, id);
    final infusions = <InfusionWithDetails>[];
    for (final inf in infusionRows) {
      FlavorProfile? infProfile;
      var infAromaTags = const <FlavorProfileAromaTag>[];
      if (inf.flavorProfileId != null) {
        infProfile = await _profileDao.getById(db, inf.flavorProfileId!);
        infAromaTags = await _profileDao.getAromaTagsForProfile(
            db, inf.flavorProfileId!);
      }
      infusions.add(InfusionWithDetails(
        infusion: inf,
        flavorProfile: infProfile,
        aromaTags: infAromaTags,
      ));
    }

    return SessionWithDetails(
      session: session,
      parameters: params,
      steps: steps,
      additives: additives,
      flavorProfile: profile,
      aromaTags: aromaTags,
      infusions: infusions,
    );
  }

  // ===================================================================
  // Writes
  // ===================================================================

  Future<int> insert(Session session) async {
    final db = await _helper.database;
    return _sessionDao.insert(db, session);
  }

  Future<int> update(Session session) async {
    final db = await _helper.database;
    return _sessionDao.update(db, session);
  }

  Future<int> delete(int id) async {
    final db = await _helper.database;
    return _sessionDao.delete(db, id);
  }

  /// Aggregat-Write: legt eine Session inkl. Parameter-Snapshot,
  /// FlavorProfile und Infusions in einer Transaktion an.
  Future<int> createWithDetails({
    required Session session,
    BrewingParameters? parameters,
    List<BrewingStep> steps = const [],
    List<BrewingAdditive> additives = const [],
    FlavorProfile? flavorProfile,
    List<FlavorProfileAromaTag> aromaTags = const [],
    List<Infusion> infusions = const [],
  }) async {
    final db = await _helper.database;
    return db.transaction<int>((txn) async {
      // 1) BrewingParameters Snapshot
      int? paramsId;
      if (parameters != null) {
        paramsId = await _brewingDao.insertParameters(txn, parameters);
        for (var i = 0; i < steps.length; i++) {
          final s = steps[i];
          await _brewingDao.insertStep(
            txn,
            BrewingStep(
              brewingParametersId: paramsId,
              stepIndex: s.stepIndex == 0 ? i : s.stepIndex,
              isRinse: s.isRinse,
              steepSeconds: s.steepSeconds,
              temperatureCelsius: s.temperatureCelsius,
            ),
          );
        }
        for (final a in additives) {
          await _brewingDao.insertAdditive(
            txn,
            BrewingAdditive(
              brewingParametersId: paramsId,
              name: a.name,
              amount: a.amount,
            ),
          );
        }
      }

      // 2) FlavorProfile (Session-Gesamteindruck)
      int? profileId;
      if (flavorProfile != null) {
        profileId = await _profileDao.insert(txn, flavorProfile);
        for (final at in aromaTags) {
          await _profileDao.insertAromaTag(
            txn,
            FlavorProfileAromaTag(
              flavorProfileId: profileId,
              aroma: at.aroma,
              tag: at.tag,
            ),
          );
        }
      }

      // 3) Session
      final sessionId = await _sessionDao.insert(
        txn,
        session.copyWith(
          brewingParametersId: paramsId,
          flavorProfileId: profileId,
        ),
      );

      // 4) Infusions
      for (var i = 0; i < infusions.length; i++) {
        final inf = infusions[i];
        await _sessionDao.insertInfusion(
          txn,
          inf.copyWith(
            sessionId: sessionId,
            infusionIndex: inf.infusionIndex == 0 ? i : inf.infusionIndex,
          ),
        );
      }

      return sessionId;
    });
  }

  // ===================================================================
  // Live-Session Helpers (optional)
  // ===================================================================

  /// Markiert eine Session als gestartet.
  Future<void> startSession(int sessionId) async {
    final session = await getById(sessionId);
    if (session == null) return;
    await update(session.copyWith(
      sessionStatus: SessionStatus.inProgress,
      start: DateTime.now(),
    ));
  }

  /// Markiert eine Session als abgeschlossen.
  Future<void> completeSession(int sessionId) async {
    final session = await getById(sessionId);
    if (session == null) return;
    await update(session.copyWith(
      sessionStatus: SessionStatus.completed,
      end: DateTime.now(),
    ));
  }

  Future<int> addInfusion(Infusion infusion) async {
    final db = await _helper.database;
    return _sessionDao.insertInfusion(db, infusion);
  }

  Future<List<Infusion>> getInfusions(int sessionId) async {
    final db = await _helper.database;
    return _sessionDao.getInfusionsForSession(db, sessionId);
  }
}
