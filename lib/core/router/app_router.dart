import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../features/auth/presentation/pages/child_mode_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/rewards/presentation/pages/rewards_page.dart';
import '../../features/shell/presentation/pages/main_shell_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import 'route_names.dart';

const _authRoutes = {RouteNames.login, RouteNames.signup, RouteNames.childMode};

/// Bridges Riverpod's [authStateProvider] stream to GoRouter's
/// [Listenable]-based `refreshListenable`, so every auth change
/// re-evaluates `redirect` without rebuilding the whole router (which
/// would otherwise reset the navigation stack).
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (loc == RouteNames.splash) return null;

      final authAsync = ref.read(authStateProvider);
      if (authAsync.isLoading) return null;

      final seenOnboarding = hasSeenOnboarding();
      if (!seenOnboarding) {
        return loc == RouteNames.onboarding ? null : RouteNames.onboarding;
      }
      if (loc == RouteNames.onboarding) return RouteNames.home;

      final loggedIn = authAsync.valueOrNull != null;
      if (!loggedIn) {
        return _authRoutes.contains(loc) ? null : RouteNames.login;
      }
      if (_authRoutes.contains(loc)) return RouteNames.home;

      return null;
    },
    routes: [
      GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashPage()),
      GoRoute(path: RouteNames.onboarding, builder: (context, state) => const OnboardingPage()),
      GoRoute(path: RouteNames.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: RouteNames.signup, builder: (context, state) => const SignupPage()),
      GoRoute(path: RouteNames.childMode, builder: (context, state) => const ChildModePage()),
      GoRoute(path: RouteNames.home, builder: (context, state) => const MainShellPage()),
      GoRoute(path: RouteNames.notifications, builder: (context, state) => const NotificationsPage()),
      GoRoute(path: RouteNames.profile, builder: (context, state) => const ProfilePage()),
      GoRoute(path: RouteNames.statistics, builder: (context, state) => const StatisticsPage()),
      GoRoute(path: RouteNames.achievements, builder: (context, state) => const AchievementsPage()),
      GoRoute(path: RouteNames.rewards, builder: (context, state) => const RewardsPage()),
    ],
  );
});
