import 'package:equatable/equatable.dart';

enum NotificationKind { milestone, reminder, achievement, system }

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.kind = NotificationKind.system,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final NotificationKind kind;

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
        kind: kind,
      );

  @override
  List<Object?> get props => [id, title, body, timestamp, isRead, kind];
}
