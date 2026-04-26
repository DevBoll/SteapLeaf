import 'package:sqflite/sqflite.dart';

import '../models/infusion.dart';

class InfusionDao {
  final Database db;
  InfusionDao(this.db);

  static const _table = 'infusions';

  Future<void> insert(Infusion i) async {
    await db.insert(
      _table,
      i.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Infusion i) async {
    await db.update(
      _table,
      i.toMap(),
      where: 'id = ?',
      whereArgs: [i.id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteBySessionId(String sessionId) async {
    await db.delete(_table, where: 'session_id = ?', whereArgs: [sessionId]);
  }

  Future<List<Infusion>> getBySessionId(String sessionId) async {
    final rows = await db.query(
      _table,
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'idx ASC',
    );
    return rows.map(Infusion.fromMap).toList();
  }
}
