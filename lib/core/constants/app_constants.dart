/// App-wide constants that aren't secrets (secrets live in `.env`, see
/// [EnvConfig]).
abstract final class AppConstants {
  static const String appName = 'Piggy Bank';
  static const String secureStorageAuthTokenKey = 'auth_token';
  static const String secureStorageRefreshTokenKey = 'refresh_token';
  static const String prefHasSeenOnboarding = 'has_seen_onboarding';
  static const String prefThemeMode = 'theme_mode';
  static const String prefLocale = 'locale';

  static const Duration splashMinDuration = Duration(milliseconds: 1600);
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 700);

  /// Milestones (in currency units) that trigger a celebration from the AI
  /// assistant / home screen confetti.
  static const List<double> savingsMilestones = [10, 25, 50, 100, 250, 500, 1000];
}
