import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../domain/notification_entity.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.kindIndex = 3,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final int kindIndex;

  factory NotificationModel.fromEntity(NotificationEntity e) => NotificationModel(
        id: e.id,
        title: e.title,
        body: e.body,
        timestamp: e.timestamp,
        isRead: e.isRead,
        kindIndex: e.kind.index,
      );

  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        isRead: isRead,
        kind: NotificationKind.values[kindIndex],
      );
}

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = HiveTypeIds.notificationModel;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      timestamp: fields[3] as DateTime,
      isRead: fields[4] as bool,
      kindIndex: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.kindIndex);
  }
}
