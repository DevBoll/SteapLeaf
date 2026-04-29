import 'enums.dart';

class Settings {
  final int sessionTimeoutSeconds;
  final bool onboardingCompleted;
  final String language;
  final ThemePreference themePreference;

  const Settings({
    this.sessionTimeoutSeconds = 300,
    this.onboardingCompleted = false,
    this.language = 'en',
    this.themePreference = ThemePreference.system,
  });

  Map<String, Object?> toMap() => {
        'id': 1,
        'sessionTimeoutSeconds': sessionTimeoutSeconds,
        'onboardingCompleted': onboardingCompleted ? 1 : 0,
        'language': language,
        'themePreference': themePreference.dbValue,
      };

  factory Settings.fromMap(Map<String, Object?> map) => Settings(
        sessionTimeoutSeconds: (map['sessionTimeoutSeconds'] as int?) ?? 300,
        onboardingCompleted:
            ((map['onboardingCompleted'] as int?) ?? 0) != 0,
        language: (map['language'] as String?) ?? 'en',
        themePreference: ThemePreference.fromDb(
            (map['themePreference'] as String?) ?? 'SYSTEM'),
      );

  Settings copyWith({
    int? sessionTimeoutSeconds,
    bool? onboardingCompleted,
    String? language,
    ThemePreference? themePreference,
  }) =>
      Settings(
        sessionTimeoutSeconds:
            sessionTimeoutSeconds ?? this.sessionTimeoutSeconds,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        language: language ?? this.language,
        themePreference: themePreference ?? this.themePreference,
      );
}
