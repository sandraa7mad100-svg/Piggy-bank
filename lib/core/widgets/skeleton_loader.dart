import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A single shimmering placeholder block. Compose several inside a
/// `Column`/`ListView` to build a skeleton loading state for any screen.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius = AppSpacing.sm});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDarkAlt : AppColors.borderLight;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(radius)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: base.withValues(alpha: 0.5));
  }
}

/// Skeleton for a list of tiles (transactions, notifications, chat history).
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              const SkeletonBox(width: 48, height: 48, radius: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(width: 140),
                    SizedBox(height: AppSpacing.xs),
                    SkeletonBox(width: 90, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
