import 'package:uuid/uuid.dart';

import '../dao/tea_dao.dart';
import '../dao/brewing_variant_dao.dart';
import '../dao/tea_tag_dao.dart';
import '../models/brewing_variant.dart';
import '../models/tea.dart';
import '../models/tags.dart';

/// Kombiniert die DAOs für `teas`, `brewing_variants` und `tea_tags`,
/// damit ein `Tea` immer mit seinen Tags und Brüh-Varianten zurückkommt.
class TeaRepository {
  final TeaDao _teaDao;
  final BrewingVariantDao _variantDao;
  final TeaTagDao _tagDao;
  final Uuid _uuid;

  TeaRepository(
    this._teaDao,
    this._variantDao,
    this._tagDao, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  // Read

  Future<Tea?> getById(String id) async {
    final row = await _teaDao.getRowById(id);
    if (row == null) return null;
    return _hydrate(row);
  }

  Future<List<Tea>> getAll() async {
    final rows = await _teaDao.getAllRows();
    return Future.wait(rows.map(_hydrate));
  }

  Future<List<Tea>> getFavorites() async {
    final rows = await _teaDao.getAllRows(where: 'is_favorite = 1');
    return Future.wait(rows.map(_hydrate));
  }

  Future<List<Tea>> getOwned() async {
    final rows = await _teaDao.getAllRows(where: 'is_owned = 1');
    return Future.wait(rows.map(_hydrate));
  }

  Future<Tea> _hydrate(Map<String, dynamic> row) async {
    final id = row['id'] as String;
    final tagIds = await _teaDao.getTagIdsForTea(id);
    final tags = await _tagDao.getByIds(tagIds);
    final variants = await _variantDao.getByTeaId(id);
    return Tea.fromMap(row, tags: tags, brewingVariants: variants);
  }

  // Create

  /// Legt einen neuen Tea an. Bei `tea.id == ''` wird eine UUID erzeugt.
  /// Tags und Brewing-Variants werden mitgespeichert.
  Future<Tea> create(Tea tea) async {
    final now = DateTime.now();
    final newTea = tea.copyWith(
      id: tea.id.isEmpty ? _uuid.v4() : tea.id,
      createdAt: tea.createdAt,
      updatedAt: now,
    );
    await _teaDao.insert(newTea);
    await _teaDao.setTagsForTea(
      newTea.id,
      newTea.tags.map((t) => t.id).toList(),
    );
    for (final v in newTea.brewingVariants) {
      await _variantDao.insert(v.copyWith(teaId: newTea.id));
    }
    return newTea;
  }

  // Update

  Future<void> update(Tea tea) async {
    final updated = tea.copyWith(updatedAt: DateTime.now());
    await _teaDao.update(updated);
    await _teaDao.setTagsForTea(
      updated.id,
      updated.tags.map((t) => t.id).toList(),
    );
    // Brewing-Variants werden separat über die jeweiligen Methoden
    // verwaltet (siehe addVariant / updateVariant / removeVariant).
  }

  Future<Tea?> toggleFavorite(String id) async {
    final tea = await getById(id);
    if (tea == null) return null;
    final next = tea.copyWith(isFavorite: !tea.isFavorite);
    await _teaDao.update(next.copyWith(updatedAt: DateTime.now()));
    return next;
  }

  Future<Tea?> setOwned(String id, bool owned) async {
    final tea = await getById(id);
    if (tea == null) return null;
    final next = tea.copyWith(isOwned: owned);
    await _teaDao.update(next.copyWith(updatedAt: DateTime.now()));
    return next;
  }

  Future<Tea?> setRating(String id, int rating) async {
    final clamped = rating.clamp(0, 5);
    final tea = await getById(id);
    if (tea == null) return null;
    final next = tea.copyWith(rating: clamped);
    await _teaDao.update(next.copyWith(updatedAt: DateTime.now()));
    return next;
  }

  // Delete

  Future<void> delete(String id) => _teaDao.delete(id);

  // Brewing-Variants

  Future<BrewingVariant> addVariant(BrewingVariant v) async {
    final newV = v.id.isEmpty ? v.copyWith(id: _uuid.v4()) : v;
    await _variantDao.insert(newV);
    if (newV.isDefault) {
      await _variantDao.setAsDefault(newV.id, newV.teaId);
    }
    return newV;
  }

  Future<void> updateVariant(BrewingVariant v) async {
    await _variantDao.update(v);
    if (v.isDefault) {
      await _variantDao.setAsDefault(v.id, v.teaId);
    }
  }

  Future<void> removeVariant(String variantId) =>
      _variantDao.delete(variantId);

  Future<void> setDefaultVariant(String variantId, String teaId) =>
      _variantDao.setAsDefault(variantId, teaId);
}
