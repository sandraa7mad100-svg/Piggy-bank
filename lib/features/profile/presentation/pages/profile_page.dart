import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final balance = ref.watch(balanceProvider);
    final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
    final completedGoals = goals.where((g) => g.isCompleted).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                AppAvatar(name: user?.displayName ?? 'Saver', photoUrl: user?.photoUrl, radius: 44),
                const SizedBox(height: AppSpacing.sm),
                Text(user?.displayName ?? 'Saver', style: context.textTheme.headlineMedium),
                if (user != null && !user.isChildMode)
                  Text(user.email, style: context.textTheme.bodyMedium),
                if (user?.isChildMode ?? false)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurpleLight,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Text('Kid Mode', style: context.textTheme.labelSmall?.copyWith(color: AppColors.accentPurple)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Balance', value: balance.toCurrency(), color: AppColors.primary)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(label: 'Goals reached', value: '$completedGoals', color: AppColors.secondary),
              ),
            ],
          ),
          if (user != null && user.createdAt.year > 1) ...[
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Member since'),
              trailing: Text('${user.createdAt.month}/${user.createdAt.year}'),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(value, style: context.textTheme.headlineMedium?.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(label, style: context.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
