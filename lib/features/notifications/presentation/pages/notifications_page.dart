import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/notification_entity.dart';
import '../providers/notifications_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  IconData _iconFor(NotificationKind kind) => switch (kind) {
        NotificationKind.milestone => Icons.celebration_rounded,
        NotificationKind.reminder => Icons.notifications_active_rounded,
        NotificationKind.achievement => Icons.emoji_events_rounded,
        NotificationKind.system => Icons.info_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'Mark all read',
            onPressed: () => ref.read(notificationsRepositoryProvider).markAllRead(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load notifications: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'All quiet here',
              message: "You'll see milestones, reminders, and achievements here.",
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final n = items[i];
              return Card(
                color: n.isRead ? null : AppColors.primaryContainer,
                child: ListTile(
                  onTap: () => ref.read(notificationsRepositoryProvider).markRead(n.id),
                  leading: Icon(_iconFor(n.kind), color: AppColors.primary),
                  title: Text(n.title, style: context.textTheme.titleMedium),
                  subtitle: Text(n.body),
                  trailing: Text(n.timestamp.toFriendlyDate(), style: context.textTheme.bodySmall),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
