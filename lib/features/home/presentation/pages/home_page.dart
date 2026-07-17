import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../ai_chat/presentation/pages/ai_chat_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../goals/presentation/pages/goals_page.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../goals/presentation/widgets/goal_progress_ring.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../providers/home_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final balance = ref.watch(balanceProvider);
    final weeklyDelta = ref.watch(weeklyNetDeltaProvider);
    final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
    final unread = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            AppAvatar(name: user?.displayName ?? 'Saver', photoUrl: user?.photoUrl),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_greeting(), style: context.textTheme.bodySmall),
                  Text(user?.displayName ?? 'Saver', style: context.textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ),
              ),
              if (unread > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionsStreamProvider);
          ref.invalidate(goalsStreamProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            BalanceCard(balance: balance, weeklyDelta: weeklyDelta),
            const SizedBox(height: AppSpacing.lg),
            QuickActionsRow(
              actions: [
                QuickAction(
                  icon: Icons.add_rounded,
                  label: 'Add',
                  color: AppColors.primary,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTransactionPage())),
                ),
                QuickAction(
                  icon: Icons.flag_rounded,
                  label: 'Goals',
                  color: AppColors.secondary,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsPage())),
                ),
                QuickAction(
                  icon: Icons.receipt_long_rounded,
                  label: 'History',
                  color: AppColors.accentBlue,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TransactionsPage())),
                ),
                QuickAction(
                  icon: Icons.savings_rounded,
                  label: 'Ask Penny',
                  color: AppColors.accentPurple,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiChatPage())),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            if (goals.isNotEmpty) ...[
              SectionHeader(
                title: 'Savings Goals',
                actionLabel: 'See all',
                onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsPage())),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: goals.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, i) {
                    final goal = goals[i];
                    return Column(
                      children: [
                        GoalProgressRing(
                          progress: goal.progress,
                          color: Color(goal.colorValue),
                          size: 64,
                          child: Text('${(goal.progress * 100).round()}%', style: context.textTheme.labelSmall),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 72,
                          child: Text(
                            goal.title,
                            style: context.textTheme.labelSmall,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
            SectionHeader(
              title: 'Recent Activity',
              actionLabel: 'See all',
              onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TransactionsPage())),
            ),
            const SizedBox(height: AppSpacing.sm),
            transactionsAsync.when(
              loading: () => const SkeletonList(itemCount: 3),
              error: (e, _) => Text('Could not load activity: $e'),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const EmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: 'No activity yet',
                    message: 'Add your first allowance or purchase to see it here.',
                  );
                }
                return Column(
                  children: [for (final t in transactions.take(5)) TransactionTile(key: ValueKey(t.id), transaction: t)],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
