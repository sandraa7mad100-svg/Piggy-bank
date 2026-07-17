import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../domain/notification_entity.dart';
import '../../domain/notifications_repository.dart';
import '../models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  Box<NotificationModel> get _box => Hive.box<NotificationModel>(HiveBoxes.notifications);

  @override
  List<NotificationEntity> getAll() {
    final items = _box.values.map((m) => m.toEntity()).toList();
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  @override
  Stream<List<NotificationEntity>> watchAll() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }

  @override
  Future<void> add(NotificationEntity notification) {
    return _box.put(notification.id, NotificationModel.fromEntity(notification));
  }

  @override
  Future<void> markRead(String id) async {
    final model = _box.get(id);
    if (model == null) return;
    await _box.put(id, NotificationModel.fromEntity(model.toEntity().copyWith(isRead: true)));
  }

  @override
  Future<void> markAllRead() async {
    for (final key in _box.keys) {
      final model = _box.get(key);
      if (model != null && !model.isRead) {
        await _box.put(key, NotificationModel.fromEntity(model.toEntity().copyWith(isRead: true)));
      }
    }
  }

  @override
  Future<void> clear() => _box.clear();

  @override
  int get unreadCount => _box.values.where((m) => !m.isRead).length;
}
