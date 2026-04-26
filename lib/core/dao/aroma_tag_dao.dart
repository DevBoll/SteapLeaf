import 'package:sqflite/sqflite.dart';

import '../models/enums.dart';
import '../models/tags.dart';

class AromaTagDao {
  final Database db;
  AromaTagDao(this.db);

  static const _table = 'aroma_tags';

  Future<void> insert(AromaTag tag) async {
    await db.insert(
      _table,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(AromaTag tag) async {
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

  Future<AromaTag?> getById(String id) async {
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : AromaTag.fromMap(rows.first);
  }

  Future<List<AromaTag>> getAll() async {
    final rows = await db.query(
      _table,
      orderBy: 'category ASC, name COLLATE NOCASE ASC',
    );
    return rows.map(AromaTag.fromMap).toList();
  }

  Future<List<AromaTag>> getByCategory(AromaCategory category) async {
    final rows = await db.query(
      _table,
      where: 'category = ?',
      whereArgs: [category.name],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(AromaTag.fromMap).toList();
  }

  Future<List<AromaTag>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await db.query(
      _table,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(AromaTag.fromMap).toList();
  }
}
