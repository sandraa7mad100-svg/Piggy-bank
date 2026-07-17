/// Centralized route paths. Using constants (rather than inline strings)
/// keeps `context.go('/home')` typos from becoming runtime navigation bugs.
abstract final class RouteNames {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const childMode = '/child-mode';

  /// Bottom-nav shell (Home / Transactions / Goals / AI Chat / Settings are
  /// tabs managed inside [MainShellPage], not separate routes).
  static const home = '/home';

  static const notifications = '/notifications';
  static const profile = '/profile';
  static const statistics = '/statistics';
  static const achievements = '/achievements';
  static const rewards = '/rewards';
}
