import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/notification_entity.dart';
import '../../domain/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) => getIt<NotificationsRepository>());

final notificationsStreamProvider = StreamProvider<List<NotificationEntity>>((ref) {
  return ref.watch(notificationsRepositoryProvider).watchAll();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsStreamProvider).valueOrNull ?? const [];
  return notifications.where((n) => !n.isRead).length;
});
