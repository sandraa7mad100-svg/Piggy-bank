import 'notification_entity.dart';

abstract class NotificationsRepository {
  List<NotificationEntity> getAll();
  Stream<List<NotificationEntity>> watchAll();
  Future<void> add(NotificationEntity notification);
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> clear();
  int get unreadCount;
}
