import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_balance_counter.dart';

/// The hero "Piggy Bank Balance" card on Home — the single most important
/// number in the app, so it gets the biggest, most animated treatment.
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.balance, required this.weeklyDelta});

  final double balance;
  final double weeklyDelta;

  @override
  Widget build(BuildContext context) {
    final isUp = weeklyDelta >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.savings_rounded, color: Colors.white70, size: 20),
              const SizedBox(width: AppSpacing.xs),
              const Text('My Piggy Bank', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedBalanceCounter(
            value: balance,
            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${isUp ? '+' : ''}\$${weeklyDelta.abs().toStringAsFixed(2)} this week',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
