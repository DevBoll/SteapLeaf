import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../models/tag.dart';

/// CRUD für Tags und die TeaTag-Junction.
class TagDao {
  static const _table = DatabaseHelper.tblTag;
  static const _junction = DatabaseHelper.tblTeaTag;

  Future<int> insert(DatabaseExecutor db, Tag tag) =>
      db.insert(_table, tag.toMap());

  Future<int> delete(DatabaseExecutor db, int id) =>
      db.delete(_table, where: 'id = ?', whereArgs: [id]);

  Future<List<Tag>> getAll(DatabaseExecutor db) async {
    final rows = await db.query(_table, orderBy: 'name COLLATE NOCASE ASC');
    return rows.map(Tag.fromMap).toList();
  }

  Future<Tag?> findByName(DatabaseExecutor db, String name) async {
    final rows = await db.query(
      _table,
      where: 'name = ? COLLATE NOCASE',
      whereArgs: [name.trim()],
      limit: 1,
    );
    return rows.isEmpty ? null : Tag.fromMap(rows.first);
  }

  /// Sucht Tag (case-insensitive) oder legt ihn neu an.
  Future<int> getOrCreate(DatabaseExecutor db, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Tag name must not be empty');
    }
    final existing = await findByName(db, trimmed);
    if (existing != null) return existing.id!;
    return db.insert(_table, {'name': trimmed});
  }

  // --- Junction (TeaTag) -------------------------------------------------

  Future<List<Tag>> getTagsForTea(DatabaseExecutor db, int teaId) async {
    final rows = await db.rawQuery(
      '''
      SELECT t.* FROM $_table t
      INNER JOIN $_junction j ON j.tagId = t.id
      WHERE j.teaId = ?
      ORDER BY t.name COLLATE NOCASE ASC
      ''',
      [teaId],
    );
    return rows.map(Tag.fromMap).toList();
  }

  Future<void> attachTag(DatabaseExecutor db, int teaId, int tagId) async {
    await db.insert(
      _junction,
      {'teaId': teaId, 'tagId': tagId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> detachTag(DatabaseExecutor db, int teaId, int tagId) =>
      db.delete(_junction,
          where: 'teaId = ? AND tagId = ?', whereArgs: [teaId, tagId]);

  Future<int> clearTagsForTea(DatabaseExecutor db, int teaId) =>
      db.delete(_junction, where: 'teaId = ?', whereArgs: [teaId]);
}
