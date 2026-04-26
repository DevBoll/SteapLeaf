import '../dao/app_settings_dao.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  final AppSettingsDao _dao;
  SettingsRepository(this._dao);

  Future<AppSettings> get() => _dao.get();

  Future<void> save(AppSettings settings) => _dao.save(settings);

  Future<AppSettings> setSessionTimeoutMinutes(int minutes) async {
    final current = await _dao.get();
    final next = current.copyWith(sessionTimeoutMinutes: minutes);
    await _dao.save(next);
    return next;
  }

  Future<AppSettings> setOnboardingCompleted(bool completed) async {
    final current = await _dao.get();
    final next = current.copyWith(onboardingCompleted: completed);
    await _dao.save(next);
    return next;
  }
}
