import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_slide.dart';

const _slides = [
  OnboardingSlideData(
    icon: Icons.savings_rounded,
    title: 'Grow your Piggy Bank',
    description: 'Track allowance, gifts, and chores — watch your balance grow every time you save.',
    color: AppColors.primary,
  ),
  OnboardingSlideData(
    icon: Icons.pie_chart_rounded,
    title: 'Spend wisely',
    description: 'See exactly where your money goes, and learn the difference between needs and wants.',
    color: AppColors.secondary,
  ),
  OnboardingSlideData(
    icon: Icons.flag_rounded,
    title: 'Set savings goals',
    description: 'Want a new bike or game? Set a goal and watch your progress ring fill up.',
    color: AppColors.accentYellowDark,
  ),
  OnboardingSlideData(
    icon: Icons.chat_bubble_rounded,
    title: 'Meet Penny, your AI buddy',
    description: 'Ask Penny anything about money — she explains things simply and cheers you on.',
    color: AppColors.accentPurple,
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  Future<void> _finish() async {
    await markOnboardingSeen();
    if (!mounted) return;
    context.go(RouteNames.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextButton(onPressed: _finish, child: const Text('Skip')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => OnboardingSlide(data: _slides[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index ? AppColors.primary : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: isLast ? 'Get started' : 'Next',
                onPressed: () {
                  if (isLast) {
                    _finish();
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
