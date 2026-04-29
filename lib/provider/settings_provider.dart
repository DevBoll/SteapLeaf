import 'package:flutter/material.dart';

import '../data/models/enums.dart';
import '../data/models/settings.dart';
import '../data/repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repo;

  SettingsProvider(this._repo);

  Settings _settings = const Settings();
  bool _initialized = false;

  Settings get settings => _settings;
  bool get initialized => _initialized;

  ThemeMode get themeMode {
    switch (_settings.themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }

  Future<void> load() async {
    _settings = await _repo.get();
    _initialized = true;
    notifyListeners();
  }

  Future<void> setTheme(ThemePreference theme) async {
    _settings = _settings.copyWith(themePreference: theme);
    notifyListeners();
    await _repo.update(_settings);
  }

  Future<void> setLanguage(String language) async {
    _settings = _settings.copyWith(language: language);
    notifyListeners();
    await _repo.update(_settings);
  }

  Future<void> setSessionTimeout(int seconds) async {
    _settings = _settings.copyWith(sessionTimeoutSeconds: seconds);
    notifyListeners();
    await _repo.update(_settings);
  }

  Future<void> completeOnboarding() async {
    if (_settings.onboardingCompleted) return;
    _settings = _settings.copyWith(onboardingCompleted: true);
    notifyListeners();
    await _repo.update(_settings);
  }
}
