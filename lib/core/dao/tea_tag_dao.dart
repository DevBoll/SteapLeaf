import 'package:sqflite/sqflite.dart';

import '../models/tags.dart';

class TeaTagDao {
  final Database db;
  TeaTagDao(this.db);

  static const _table = 'tea_tags';

  Future<void> insert(TeaTag tag) async {
    await db.insert(
      _table,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(TeaTag tag) async {
    await db.update(
      _table,
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<TeaTag?> getById(String id) async {
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : TeaTag.fromMap(rows.first);
  }

  Future<List<TeaTag>> getAll() async {
    final rows = await db.query(
      _table,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(TeaTag.fromMap).toList();
  }

  Future<List<TeaTag>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await db.query(
      _table,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(TeaTag.fromMap).toList();
  }
}
