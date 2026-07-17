import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../goals/presentation/widgets/goal_progress_ring.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../../../transactions/presentation/widgets/category_breakdown_chart.dart';
import '../../../transactions/presentation/widgets/weekly_spending_chart.dart';
import '../providers/statistics_provider.dart';
import '../widgets/monthly_spending_chart.dart';
import '../widgets/savings_progress_chart.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingsProgress = ref.watch(savingsProgressProvider);
    final monthlySpending = ref.watch(monthlySpendingProvider);
    final weeklySpending = ref.watch(weeklySpendingProvider);
    final breakdown = ref.watch(categoryBreakdownProvider);
    final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _ChartCard(title: 'Savings progress', child: SavingsProgressChart(points: savingsProgress)),
          const SizedBox(height: AppSpacing.md),
          _ChartCard(title: 'Monthly spending', child: MonthlySpendingChart(monthlyTotals: monthlySpending)),
          const SizedBox(height: AppSpacing.md),
          _ChartCard(title: 'This week', child: WeeklySpendingChart(dailyTotals: weeklySpending)),
          const SizedBox(height: AppSpacing.md),
          _ChartCard(title: 'Spending by category', child: CategoryBreakdownChart(breakdown: breakdown)),
          const SizedBox(height: AppSpacing.md),
          if (goals.isNotEmpty)
            _ChartCard(
              title: 'Goal completion',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.md,
                children: [
                  for (final g in goals)
                    Column(
                      children: [
                        GoalProgressRing(
                          progress: g.progress,
                          color: Color(g.colorValue),
                          child: Text('${(g.progress * 100).round()}%', style: context.textTheme.labelSmall),
                        ),
                        const SizedBox(height: 4),
                        Text(g.title, style: context.textTheme.labelSmall),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}
