import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../domain/entities/user_entity.dart';

/// Hive-persisted user profile, cached locally so Home/Settings can render
/// instantly offline and so "Kid mode" (anonymous auth) has somewhere to
/// keep its profile without a server round-trip.
class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isChildMode = false,
    this.currency = 'USD',
    required this.createdAt,
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isChildMode;
  final String currency;
  final DateTime createdAt;

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        displayName: entity.displayName,
        photoUrl: entity.photoUrl,
        isChildMode: entity.isChildMode,
        currency: entity.currency,
        createdAt: entity.createdAt,
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        isChildMode: isChildMode,
        currency: currency,
        createdAt: createdAt,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String,
        photoUrl: json['photoUrl'] as String?,
        isChildMode: json['isChildMode'] as bool? ?? false,
        currency: json['currency'] as String? ?? 'USD',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'isChildMode': isChildMode,
        'currency': currency,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Hand-written Hive adapter (mirrors what `hive_generator` would emit) —
/// see [HiveService] for why adapters aren't code-generated in this
/// project.
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = HiveTypeIds.userModel;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String,
      photoUrl: fields[3] as String?,
      isChildMode: fields[4] as bool,
      currency: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.isChildMode)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.createdAt);
  }
}
