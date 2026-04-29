import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../models/enums.dart';
import '../models/session.dart';

class SessionDao {
  static const _tblSession = DatabaseHelper.tblSession;
  static const _tblInfusion = DatabaseHelper.tblInfusion;

  // ===================================================================
  // Session
  // ===================================================================

  Future<int> insert(DatabaseExecutor db, Session session) =>
      db.insert(_tblSession, session.toMap());

  Future<int> update(DatabaseExecutor db, Session session) {
    if (session.id == null) {
      throw ArgumentError('Session.id must not be null for update');
    }
    return db.update(_tblSession, session.toMap(),
        where: 'id = ?', whereArgs: [session.id]);
  }

  Future<int> delete(DatabaseExecutor db, int id) =>
      db.delete(_tblSession, where: 'id = ?', whereArgs: [id]);

  Future<Session?> getById(DatabaseExecutor db, int id) async {
    final rows = await db.query(_tblSession,
        where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Session.fromMap(rows.first);
  }

  Future<List<Session>> getAll(
    DatabaseExecutor db, {
    int? teaId,
    SessionStatus? status,
    SessionType? type,
    int limit = 200,
    int offset = 0,
  }) async {
    final whereParts = <String>[];
    final args = <Object?>[];
    if (teaId != null) {
      whereParts.add('teaId = ?');
      args.add(teaId);
    }
    if (status != null) {
      whereParts.add('sessionStatus = ?');
      args.add(status.dbValue);
    }
    if (type != null) {
      whereParts.add('sessionType = ?');
      args.add(type.dbValue);
    }
    final rows = await db.query(
      _tblSession,
      where: whereParts.isEmpty ? null : whereParts.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'timestamp DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(Session.fromMap).toList();
  }

  // ===================================================================
  // Infusion
  // ===================================================================

  Future<int> insertInfusion(DatabaseExecutor db, Infusion inf) =>
      db.insert(_tblInfusion, inf.toMap());

  Future<int> updateInfusion(DatabaseExecutor db, Infusion inf) {
    if (inf.id == null) {
      throw ArgumentError('Infusion.id must not be null for update');
    }
    return db.update(_tblInfusion, inf.toMap(),
        where: 'id = ?', whereArgs: [inf.id]);
  }

  Future<int> deleteInfusion(DatabaseExecutor db, int id) =>
      db.delete(_tblInfusion, where: 'id = ?', whereArgs: [id]);

  Future<Infusion?> getInfusionById(DatabaseExecutor db, int id) async {
    final rows = await db.query(_tblInfusion,
        where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Infusion.fromMap(rows.first);
  }

  Future<List<Infusion>> getInfusionsForSession(
      DatabaseExecutor db, int sessionId) async {
    final rows = await db.query(
      _tblInfusion,
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      orderBy: 'infusionIndex ASC',
    );
    return rows.map(Infusion.fromMap).toList();
  }
}
