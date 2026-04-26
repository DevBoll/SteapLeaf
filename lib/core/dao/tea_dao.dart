import 'package:sqflite/sqflite.dart';

import '../models/tea.dart';

/// DAO für die `teas`-Tabelle und die Junction `tea_tea_tags`.
/// Lädt Tea OHNE seine Tags und Brewing-Variants – das macht das Repository.
class TeaDao {
  final Database db;
  TeaDao(this.db);

  static const _table = 'teas';
  static const _junction = 'tea_tea_tags';

  Future<void> insert(Tea tea) async {
    await db.insert(
      _table,
      tea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Tea tea) async {
    await db.update(
      _table,
      tea.toMap(),
      where: 'id = ?',
      whereArgs: [tea.id],
    );
  }

  /// Löschen kaskadiert auf brewing_variants und tea_tea_tags via FK.
  Future<void> delete(String id) async {
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getRowById(String id) async {
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, dynamic>>> getAllRows({
    String? orderBy = 'name COLLATE NOCASE ASC',
    String? where,
    List<Object?>? whereArgs,
  }) {
    return db.query(
      _table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  // Junction Tea, TeaTag

  Future<List<String>> getTagIdsForTea(String teaId) async {
    final rows = await db.query(
      _junction,
      columns: ['tag_id'],
      where: 'tea_id = ?',
      whereArgs: [teaId],
    );
    return rows.map((r) => r['tag_id'] as String).toList();
  }

  Future<void> setTagsForTea(String teaId, List<String> tagIds) async {
    await db.transaction((txn) async {
      await txn.delete(
        _junction,
        where: 'tea_id = ?',
        whereArgs: [teaId],
      );
      for (final tagId in tagIds) {
        await txn.insert(
          _junction,
          {'tea_id': teaId, 'tag_id': tagId},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }
}
