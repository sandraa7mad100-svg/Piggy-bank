import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../providers/goals_provider.dart';
import '../widgets/goal_progress_ring.dart';
import 'add_goal_page.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goals')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddGoalPage())),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New goal'),
      ),
      body: goalsAsync.when(
        loading: () => const Padding(padding: EdgeInsets.all(AppSpacing.md), child: SkeletonList()),
        error: (e, _) => Center(child: Text('Could not load goals: $e')),
        data: (goals) {
          if (goals.isEmpty) {
            return const EmptyState(
              icon: Icons.flag_rounded,
              title: 'No goals yet',
              message: 'Set a savings goal — like a new bike or a game — and watch your progress grow.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: goals.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => _GoalCard(goal: goals[i]),
          );
        },
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.goal});
  final SavingsGoalEntity goal;

  Future<void> _addFunds(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to "${goal.title}"'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(prefixText: '\$ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, double.tryParse(controller.text.trim())),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (amount != null && amount > 0) {
      await ref.read(goalsControllerProvider.notifier).contribute(goal.id, amount);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(goal.colorValue);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            GoalProgressRing(
              progress: goal.progress,
              color: color,
              child: Text('${(goal.progress * 100).round()}%', style: context.textTheme.labelSmall),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: context.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    '${goal.currentAmount.toCurrency()} of ${goal.targetAmount.toCurrency()}',
                    style: context.textTheme.bodySmall,
                  ),
                  if (goal.isCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Goal reached! 🎉', style: context.textTheme.bodySmall?.copyWith(color: color)),
                    ),
                ],
              ),
            ),
            if (!goal.isCompleted)
              PrimaryButton(
                label: 'Add',
                expand: false,
                color: color,
                onPressed: () => _addFunds(context, ref),
              ),
          ],
        ),
      ),
    );
  }
}
