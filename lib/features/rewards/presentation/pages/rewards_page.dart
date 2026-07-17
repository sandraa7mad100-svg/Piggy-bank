import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';

class _RewardTier {
  const _RewardTier(this.threshold, this.title, this.icon);
  final double threshold;
  final String title;
  final IconData icon;
}

const _tiers = [
  _RewardTier(10, 'Bronze Saver', Icons.workspace_premium_rounded),
  _RewardTier(50, 'Silver Saver', Icons.workspace_premium_rounded),
  _RewardTier(100, 'Gold Saver', Icons.workspace_premium_rounded),
  _RewardTier(250, 'Platinum Saver', Icons.workspace_premium_rounded),
  _RewardTier(500, 'Diamond Saver', Icons.diamond_rounded),
];

/// Reward tiers unlock automatically as the piggy bank balance grows —
/// a lightweight, always-in-sync alternative to a separate rewards ledger.
class RewardsPage extends ConsumerWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final nextTier = _tiers.where((t) => balance < t.threshold).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (nextTier != null)
            Card(
              color: AppColors.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next reward: ${nextTier.title}', style: context.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Save ${(nextTier.threshold - balance).toCurrency()} more to unlock it!',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      child: LinearProgressIndicator(
                        value: (balance / nextTier.threshold).clamp(0, 1),
                        minHeight: 8,
                        backgroundColor: Colors.white,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          for (final tier in _tiers)
            Card(
              child: ListTile(
                leading: Icon(
                  tier.icon,
                  color: balance >= tier.threshold ? AppColors.accentYellowDark : AppColors.textSecondaryLight,
                ),
                title: Text(tier.title),
                subtitle: Text('Reach ${tier.threshold.toCurrency()} saved'),
                trailing: balance >= tier.threshold
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.success)
                    : const Icon(Icons.lock_outline_rounded),
              ),
            ),
        ],
      ),
    );
  }
}
