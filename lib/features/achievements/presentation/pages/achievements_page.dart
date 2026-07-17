import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';

class Achievement {
  const Achievement({required this.icon, required this.title, required this.description, required this.unlocked});
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;
}

/// Achievements are derived entirely from live data (transaction/goal
/// counts and totals) rather than stored separately, so they can never
/// drift out of sync with what actually happened.
class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsStreamProvider).valueOrNull ?? const [];
    final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
    final balance = ref.watch(balanceProvider);
    final completedGoals = goals.where((g) => g.isCompleted).length;

    final achievements = [
      Achievement(
        icon: Icons.savings_rounded,
        title: 'First Deposit',
        description: 'Log your first transaction',
        unlocked: transactions.isNotEmpty,
      ),
      Achievement(
        icon: Icons.flag_rounded,
        title: 'Goal Setter',
        description: 'Create your first savings goal',
        unlocked: goals.isNotEmpty,
      ),
      Achievement(
        icon: Icons.emoji_events_rounded,
        title: 'Goal Getter',
        description: 'Complete a savings goal',
        unlocked: completedGoals > 0,
      ),
      Achievement(
        icon: Icons.trending_up_rounded,
        title: 'Big Saver',
        description: 'Reach a \$50 balance',
        unlocked: balance >= 50,
      ),
      Achievement(
        icon: Icons.stars_rounded,
        title: 'Super Saver',
        description: 'Reach a \$100 balance',
        unlocked: balance >= 100,
      ),
      Achievement(
        icon: Icons.receipt_long_rounded,
        title: 'Tracker',
        description: 'Log 10 transactions',
        unlocked: transactions.length >= 10,
      ),
      Achievement(
        icon: Icons.balance_rounded,
        title: 'Smart Spender',
        description: 'Tag 5 purchases as needs or wants',
        unlocked: transactions.where((t) => t.type.name == 'expense').length >= 5,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.95,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, i) {
          final a = achievements[i];
          return Card(
            color: a.unlocked ? null : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: a.unlocked ? AppColors.accentYellow.withValues(alpha: 0.2) : AppColors.borderLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a.icon, color: a.unlocked ? AppColors.accentYellowDark : AppColors.textSecondaryLight, size: 28),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(a.title, textAlign: TextAlign.center, style: context.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    a.description,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
