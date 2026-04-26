/// Globale App-Einstellungen, persistiert als Single-Row.
class AppSettings {
  final int sessionTimeoutMinutes;
  final bool onboardingCompleted;

  const AppSettings({
    this.sessionTimeoutMinutes = 5,
    this.onboardingCompleted = false,
  });

  static const defaults = AppSettings();

  AppSettings copyWith({
    int? sessionTimeoutMinutes,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      onboardingCompleted:
          onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': 1,
        'session_timeout_minutes': sessionTimeoutMinutes,
        'onboarding_completed': onboardingCompleted ? 1 : 0,
      };

  factory AppSettings.fromMap(Map<String, dynamic> m) => AppSettings(
        sessionTimeoutMinutes:
            (m['session_timeout_minutes'] as int?) ?? 5,
        onboardingCompleted:
            (m['onboarding_completed'] as int? ?? 0) == 1,
      );
}
