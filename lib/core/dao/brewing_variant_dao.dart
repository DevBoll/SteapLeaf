import 'package:sqflite/sqflite.dart';

import '../models/brewing_variant.dart';

class BrewingVariantDao {
  final Database db;
  BrewingVariantDao(this.db);

  static const _table = 'brewing_variants';

  Future<void> insert(BrewingVariant v) async {
    await db.insert(
      _table,
      v.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(BrewingVariant v) async {
    await db.update(
      _table,
      v.toMap(),
      where: 'id = ?',
      whereArgs: [v.id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<BrewingVariant?> getById(String id) async {
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : BrewingVariant.fromMap(rows.first);
  }

  Future<List<BrewingVariant>> getByTeaId(String teaId) async {
    final rows = await db.query(
      _table,
      where: 'tea_id = ?',
      whereArgs: [teaId],
      orderBy: 'is_default DESC, name COLLATE NOCASE ASC',
    );
    return rows.map(BrewingVariant.fromMap).toList();
  }

  /// Setzt die Variante als einzigen Default für ihren Tee.
  /// Macht alle anderen Varianten desselben Tees zu Nicht-Default.
  Future<void> setAsDefault(String variantId, String teaId) async {
    await db.transaction((txn) async {
      await txn.update(
        _table,
        {'is_default': 0},
        where: 'tea_id = ?',
        whereArgs: [teaId],
      );
      await txn.update(
        _table,
        {'is_default': 1},
        where: 'id = ?',
        whereArgs: [variantId],
      );
    });
  }
}
