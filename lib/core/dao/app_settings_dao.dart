import 'package:sqflite/sqflite.dart';

import '../models/app_settings.dart';

class AppSettingsDao {
  final Database db;
  AppSettingsDao(this.db);

  static const _table = 'app_settings';

  Future<AppSettings> get() async {
    final rows = await db.query(_table, where: 'id = 1');
    if (rows.isEmpty) {
      // Defensive: Falls die Default-Row fehlt, anlegen.
      await db.insert(_table, AppSettings.defaults.toMap());
      return AppSettings.defaults;
    }
    return AppSettings.fromMap(rows.first);
  }

  Future<void> save(AppSettings settings) async {
    await db.update(
      _table,
      settings.toMap(),
      where: 'id = 1',
    );
  }
}
