import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../models/settings.dart';

class SettingsDao {
  static const _table = DatabaseHelper.tblSettings;

  Future<Settings?> get(DatabaseExecutor db) async {
    final rows = await db.query(_table, where: 'id = 1', limit: 1);
    return rows.isEmpty ? null : Settings.fromMap(rows.first);
  }

  Future<int> update(DatabaseExecutor db, Settings settings) =>
      db.update(_table, settings.toMap(), where: 'id = 1');

  Future<int> insertIfMissing(DatabaseExecutor db, Settings defaults) =>
      db.insert(_table, defaults.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
}
