import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateWhenReady();
  }

  Future<void> _navigateWhenReady() async {
    final minDelay = Future<void>.delayed(AppConstants.splashMinDuration);
    UserEntity? user;
    try {
      user = await ref.read(authStateProvider.future);
    } catch (_) {
      user = null;
    }
    await minDelay;
    if (!mounted) return;

    if (!hasSeenOnboarding()) {
      context.go(RouteNames.onboarding);
    } else if (user == null) {
      context.go(RouteNames.login);
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.savings_rounded, size: 64, color: AppColors.primary),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut).fadeIn(duration: 300.ms),
            const SizedBox(height: 24),
            const Text(
              'Piggy Bank',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 8),
            const Text(
              'Save. Spend smart. Grow.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
