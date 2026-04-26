import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repo;
  SettingsProvider(this._repo);

  AppSettings _settings = AppSettings.defaults;
  bool _loading = false;

  AppSettings get settings => _settings;
  bool get loading => _loading;

  int get sessionTimeoutMinutes => _settings.sessionTimeoutMinutes;
  bool get onboardingCompleted => _settings.onboardingCompleted;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _settings = await _repo.get();
    _loading = false;
    notifyListeners();
  }

  Future<void> setSessionTimeoutMinutes(int minutes) async {
    _settings = await _repo.setSessionTimeoutMinutes(minutes);
    notifyListeners();
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    _settings = await _repo.setOnboardingCompleted(completed);
    notifyListeners();
  }
}
