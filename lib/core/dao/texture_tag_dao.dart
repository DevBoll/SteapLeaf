import 'package:sqflite/sqflite.dart';

import '../models/tags.dart';

class TextureTagDao {
  final Database db;
  TextureTagDao(this.db);

  static const _table = 'texture_tags';

  Future<void> insert(TextureTag tag) async {
    await db.insert(
      _table,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(TextureTag tag) async {
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

  Future<TextureTag?> getById(String id) async {
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : TextureTag.fromMap(rows.first);
  }

  Future<List<TextureTag>> getAll() async {
    final rows = await db.query(
      _table,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(TextureTag.fromMap).toList();
  }
}
