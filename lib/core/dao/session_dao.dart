import 'package:sqflite/sqflite.dart';

import '../models/enums.dart';
import '../models/session.dart';

class SessionDao {
  final Database db;
  SessionDao(this.db);

  static const _table = 'sessions';

  Future<void> insert(Session s) async {
    await db.insert(
      _table,
      s.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Session s) async {
    await db.update(
      _table,
      s.toMap(),
      where: 'id = ?',
      whereArgs: [s.id],
    );
  }

  /// Kaskadiert auf infusions via FK.
  Future<void> delete(String id) async {
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getRowById(String id) async {
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, dynamic>>> getAllRows({
    int? limit,
    int? offset,
  }) {
    return db.query(
      _table,
      orderBy: 'date_time DESC',
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, dynamic>>> getRowsByTeaId(String teaId) {
    return db.query(
      _table,
      where: 'tea_id = ?',
      whereArgs: [teaId],
      orderBy: 'date_time DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getRowsByStatus(SessionStatus status) {
    return db.query(
      _table,
      where: 'status = ?',
      whereArgs: [status.name],
      orderBy: 'date_time DESC',
    );
  }
}
