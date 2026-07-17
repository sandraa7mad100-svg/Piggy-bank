import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel {
  ChatMessageModel({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isMilestone = false,
  });

  final String id;
  final String content;
  final ChatRole role;
  final DateTime timestamp;
  final bool isMilestone;

  factory ChatMessageModel.fromEntity(ChatMessageEntity e) => ChatMessageModel(
        id: e.id,
        content: e.content,
        role: e.role,
        timestamp: e.timestamp,
        isMilestone: e.isMilestone,
      );

  ChatMessageEntity toEntity() => ChatMessageEntity(
        id: id,
        content: content,
        role: role,
        timestamp: timestamp,
        isMilestone: isMilestone,
      );
}

class ChatMessageModelAdapter extends TypeAdapter<ChatMessageModel> {
  @override
  final int typeId = HiveTypeIds.chatMessageModel;

  @override
  ChatMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageModel(
      id: fields[0] as String,
      content: fields[1] as String,
      role: fields[2] as ChatRole,
      timestamp: fields[3] as DateTime,
      isMilestone: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.isMilestone);
  }
}

class ChatRoleAdapter extends TypeAdapter<ChatRole> {
  @override
  final int typeId = HiveTypeIds.chatRole;

  @override
  ChatRole read(BinaryReader reader) => ChatRole.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, ChatRole obj) => writer.writeByte(obj.index);
}
