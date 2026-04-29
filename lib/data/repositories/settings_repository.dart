import '../dao/settings_dao.dart';
import '../database_helper.dart';
import '../models/settings.dart';

class SettingsRepository {
  final DatabaseHelper _helper;
  final SettingsDao _dao;

  SettingsRepository({
    required DatabaseHelper helper,
    required SettingsDao dao,
  })  : _helper = helper,
        _dao = dao;

  Future<Settings> get() async {
    final db = await _helper.database;
    final settings = await _dao.get(db);
    if (settings != null) return settings;
    // Fallback: Defaults schreiben (sollte durch _onCreate bereits geschehen sein)
    const defaults = Settings();
    await _dao.insertIfMissing(db, defaults);
    return defaults;
  }

  Future<void> update(Settings settings) async {
    final db = await _helper.database;
    await _dao.update(db, settings);
  }
}
