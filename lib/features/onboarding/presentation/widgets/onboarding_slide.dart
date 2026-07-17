import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_spacing.dart';

class OnboardingSlideData {
  const OnboardingSlideData({required this.icon, required this.title, required this.description, required this.color});
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.data});

  final OnboardingSlideData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(color: data.color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(data.icon, size: 96, color: data.color),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack).fadeIn(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
