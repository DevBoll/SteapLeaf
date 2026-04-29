import 'package:sqflite/sqflite.dart';

import '../dao/brewing_dao.dart';
import '../dao/flavor_profile_dao.dart';
import '../dao/tag_dao.dart';
import '../dao/tea_dao.dart';
import '../database_helper.dart';
import '../models/brewing.dart';
import '../models/flavor_profile.dart';
import '../models/tag.dart';
import '../models/tea.dart';

/// Geschäftslogik rund um Tees:
/// fasst Tea + FlavorProfile + Tags + BrewingVariants zusammen.
class TeaRepository {
  final DatabaseHelper _helper;
  final TeaDao _teaDao;
  final TagDao _tagDao;
  final FlavorProfileDao _profileDao;
  final BrewingDao _brewingDao;

  TeaRepository({
    required DatabaseHelper helper,
    required TeaDao teaDao,
    required TagDao tagDao,
    required FlavorProfileDao profileDao,
    required BrewingDao brewingDao,
  })  : _helper = helper,
        _teaDao = teaDao,
        _tagDao = tagDao,
        _profileDao = profileDao,
        _brewingDao = brewingDao;

  // ===================================================================
  // Reads
  // ===================================================================

  Future<List<Tea>> getAll({
    bool? ownedOnly,
    bool? favoritesOnly,
    String? type,
    String? search,
  }) async {
    final db = await _helper.database;
    return _teaDao.getAll(
      db,
      ownedOnly: ownedOnly,
      favoritesOnly: favoritesOnly,
      type: type,
      search: search,
    );
  }

  Future<Tea?> getById(int id) async {
    final db = await _helper.database;
    return _teaDao.getById(db, id);
  }

  /// Aggregat-Query: Tee mit FlavorProfile, AromaTags, Tags und allen
  /// BrewingVariants (inkl. Parameters/Steps/Additive).
  Future<TeaWithDetails?> getWithDetails(int id) async {
    final db = await _helper.database;
    final tea = await _teaDao.getById(db, id);
    if (tea == null) return null;

    FlavorProfile? profile;
    var aromaTags = const <FlavorProfileAromaTag>[];
    if (tea.flavorProfileId != null) {
      profile = await _profileDao.getById(db, tea.flavorProfileId!);
      aromaTags =
          await _profileDao.getAromaTagsForProfile(db, tea.flavorProfileId!);
    }

    final tags = await _tagDao.getTagsForTea(db, id);
    final variants = await _loadVariantsWithDetails(db, id);

    return TeaWithDetails(
      tea: tea,
      flavorProfile: profile,
      aromaTags: aromaTags,
      tags: tags,
      brewingVariants: variants,
    );
  }

  Future<List<BrewingVariantWithDetails>> _loadVariantsWithDetails(
      DatabaseExecutor db, int teaId) async {
    final variants = await _brewingDao.getVariantsForTea(db, teaId);
    final result = <BrewingVariantWithDetails>[];
    for (final v in variants) {
      BrewingParameters? params;
      var steps = const <BrewingStep>[];
      var additives = const <BrewingAdditive>[];
      if (v.brewingParametersId != null) {
        params = await _brewingDao.getParameters(db, v.brewingParametersId!);
        steps =
            await _brewingDao.getStepsForParameters(db, v.brewingParametersId!);
        additives = await _brewingDao.getAdditivesForParameters(
            db, v.brewingParametersId!);
      }
      result.add(BrewingVariantWithDetails(
        variant: v,
        parameters: params,
        steps: steps,
        additives: additives,
      ));
    }
    return result;
  }

  // ===================================================================
  // Writes — einfach
  // ===================================================================

  Future<int> insert(Tea tea) async {
    final db = await _helper.database;
    return _teaDao.insert(db, tea);
  }

  Future<int> update(Tea tea) async {
    final db = await _helper.database;
    return _teaDao.update(db, tea);
  }

  Future<int> delete(int id) async {
    final db = await _helper.database;
    return _teaDao.delete(db, id);
  }

  Future<void> toggleFavorite(int id) async {
    final db = await _helper.database;
    await db.transaction((txn) async {
      final tea = await _teaDao.getById(txn, id);
      if (tea == null) return;
      await _teaDao.update(txn, tea.copyWith(isFavorite: !tea.isFavorite));
    });
  }

  // ===================================================================
  // Writes — Aggregat (transaktional)
  // ===================================================================

  /// Legt einen Tee inkl. FlavorProfile, AromaTags, Tag-Liste und
  /// BrewingVariants in einer Transaktion an.
  Future<int> createWithDetails({
    required Tea tea,
    FlavorProfile? flavorProfile,
    List<FlavorProfileAromaTag> aromaTags = const [],
    List<String> tagNames = const [],
    List<BrewingVariantWithDetails> brewingVariants = const [],
  }) async {
    final db = await _helper.database;
    return db.transaction<int>((txn) async {
      // 1) FlavorProfile (+ AromaTags)
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

      // 2) Tea
      final teaId = await _teaDao.insert(
        txn,
        tea.copyWith(flavorProfileId: profileId),
      );

      // 3) Tags
      for (final name in tagNames) {
        if (name.trim().isEmpty) continue;
        final tagId = await _tagDao.getOrCreate(txn, name);
        await _tagDao.attachTag(txn, teaId, tagId);
      }

      // 4) BrewingVariants
      for (final v in brewingVariants) {
        await _insertVariantInTxn(txn, teaId, v);
      }

      return teaId;
    });
  }

  /// Legt eine zusätzliche BrewingVariant an einen bestehenden Tee an.
  Future<int> addBrewingVariant(
      int teaId, BrewingVariantWithDetails details) async {
    final db = await _helper.database;
    return db
        .transaction<int>((txn) => _insertVariantInTxn(txn, teaId, details));
  }

  Future<int> _insertVariantInTxn(
    DatabaseExecutor txn,
    int teaId,
    BrewingVariantWithDetails details,
  ) async {
    int? paramsId;
    if (details.parameters != null) {
      paramsId = await _brewingDao.insertParameters(txn, details.parameters!);
      for (var i = 0; i < details.steps.length; i++) {
        final s = details.steps[i];
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
      for (final a in details.additives) {
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

    if (details.variant.isDefault) {
      await _brewingDao.clearDefaultsForTea(txn, teaId);
    }

    return _brewingDao.insertVariant(
      txn,
      details.variant.copyWith(
        teaId: teaId,
        brewingParametersId: paramsId,
      ),
    );
  }

  /// Setzt EINE Variante als Default ihres Tees (transaktional).
  Future<void> setDefaultVariant(int variantId) async {
    final db = await _helper.database;
    await db.transaction((txn) async {
      final variant = await _brewingDao.getVariant(txn, variantId);
      if (variant == null) {
        throw StateError('BrewingVariant $variantId not found');
      }
      await _brewingDao.clearDefaultsForTea(txn, variant.teaId);
      await _brewingDao.updateVariant(
        txn,
        variant.copyWith(isDefault: true),
      );
    });
  }

  Future<int> deleteVariant(int variantId) async {
    final db = await _helper.database;
    return _brewingDao.deleteVariant(db, variantId);
  }

  /// Setzt die Tag-Liste eines Tees komplett neu (transaktional).
  Future<void> setTags(int teaId, List<String> tagNames) async {
    final db = await _helper.database;
    await db.transaction((txn) async {
      await _tagDao.clearTagsForTea(txn, teaId);
      for (final name in tagNames) {
        if (name.trim().isEmpty) continue;
        final tagId = await _tagDao.getOrCreate(txn, name);
        await _tagDao.attachTag(txn, teaId, tagId);
      }
    });
  }

  Future<List<Tag>> getAllTags() async {
    final db = await _helper.database;
    return _tagDao.getAll(db);
  }
}
