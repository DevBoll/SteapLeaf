import 'package:uuid/uuid.dart';

import '../dao/brewing_variant_dao.dart';
import '../dao/infusion_dao.dart';
import '../dao/session_dao.dart';
import '../models/brewing_variant.dart';
import '../models/enums.dart';
import '../models/infusion.dart';
import '../models/session.dart';

/// Verwaltet Sessions inklusive ihrer Infusions.
/// Übernimmt das Snapshotten der Brüh-Parameter beim Start.
class SessionRepository {
  final SessionDao _sessionDao;
  final InfusionDao _infusionDao;
  final BrewingVariantDao _variantDao;
  final Uuid _uuid;

  SessionRepository(
    this._sessionDao,
    this._infusionDao,
    this._variantDao, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  // Read

  Future<Session?> getById(String id) async {
    final row = await _sessionDao.getRowById(id);
    if (row == null) return null;
    final infusions = await _infusionDao.getBySessionId(id);
    return Session.fromMap(row, infusions: infusions);
  }

  Future<List<Session>> getAll({int? limit, int? offset}) async {
    final rows = await _sessionDao.getAllRows(limit: limit, offset: offset);
    return Future.wait(rows.map(_hydrate));
  }

  Future<List<Session>> getByTeaId(String teaId) async {
    final rows = await _sessionDao.getRowsByTeaId(teaId);
    return Future.wait(rows.map(_hydrate));
  }

  Future<List<Session>> getByStatus(SessionStatus status) async {
    final rows = await _sessionDao.getRowsByStatus(status);
    return Future.wait(rows.map(_hydrate));
  }

  Future<Session> _hydrate(Map<String, dynamic> row) async {
    final infusions = await _infusionDao.getBySessionId(row['id'] as String);
    return Session.fromMap(row, infusions: infusions);
  }

  // Lifecycle

  /// Startet eine Session aus einer existierenden Variante (snapshottet
  /// brewing_type + parameters). Liefert die persistierte Session zurück.
  Future<Session> startFromVariant({
    required String teaId,
    required String variantId,
    SessionType sessionType = SessionType.simple,
  }) async {
    final variant = await _variantDao.getById(variantId);
    if (variant == null) {
      throw StateError('BrewingVariant $variantId nicht gefunden');
    }
    final now = DateTime.now();
    final session = Session(
      id: _uuid.v4(),
      dateTime: now,
      sessionType: sessionType,
      teaId: teaId,
      brewingVariantId: variant.id,
      status: SessionStatus.active,
      brewingType: variant.brewingType,
      brewingParameters: variant.parameters,
      isManual: false,
      start: now,
    );
    await _sessionDao.insert(session);
    return session;
  }

  /// Startet eine manuelle Session (externer Tee oder ohne Variante).
  Future<Session> startManual({
    required Session draft,
  }) async {
    final now = DateTime.now();
    final session = draft.copyWith(
      id: draft.id.isEmpty ? _uuid.v4() : draft.id,
      dateTime: draft.dateTime,
      status: SessionStatus.active,
      isManual: true,
      start: now,
    );
    await _sessionDao.insert(session);
    return session;
  }

  Future<void> update(Session session) => _sessionDao.update(session);

  Future<Session?> setStatus(String id, SessionStatus status) async {
    final s = await getById(id);
    if (s == null) return null;
    final next = s.copyWith(
      status: status,
      end: status == SessionStatus.completed ||
              status == SessionStatus.discarded
          ? DateTime.now()
          : s.end,
    );
    await _sessionDao.update(next);
    return next;
  }

  Future<Session?> complete(String id) =>
      setStatus(id, SessionStatus.completed);

  Future<Session?> discard(String id) =>
      setStatus(id, SessionStatus.discarded);

  Future<Session?> markInterrupted(String id) =>
      setStatus(id, SessionStatus.interrupted);

  Future<void> delete(String id) => _sessionDao.delete(id);

  // Infusions 

  Future<Infusion> addInfusion(Infusion infusion) async {
    final newI = infusion.id.isEmpty
        ? infusion.copyWith(id: _uuid.v4())
        : infusion;
    await _infusionDao.insert(newI);
    return newI;
  }

  Future<void> updateInfusion(Infusion infusion) =>
      _infusionDao.update(infusion);

  Future<void> removeInfusion(String infusionId) =>
      _infusionDao.delete(infusionId);
}
