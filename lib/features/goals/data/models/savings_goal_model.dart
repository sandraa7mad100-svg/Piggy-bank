import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../domain/entities/savings_goal_entity.dart';

class SavingsGoalModel {
  SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.createdAt,
    this.iconKey = 'toys',
    this.colorValue = 0xFFFF6B9D,
    this.targetDate,
  });

  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdAt;
  final String iconKey;
  final int colorValue;
  final DateTime? targetDate;

  factory SavingsGoalModel.fromEntity(SavingsGoalEntity e) => SavingsGoalModel(
        id: e.id,
        title: e.title,
        targetAmount: e.targetAmount,
        currentAmount: e.currentAmount,
        createdAt: e.createdAt,
        iconKey: e.iconKey,
        colorValue: e.colorValue,
        targetDate: e.targetDate,
      );

  SavingsGoalEntity toEntity() => SavingsGoalEntity(
        id: id,
        title: title,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        createdAt: createdAt,
        iconKey: iconKey,
        colorValue: colorValue,
        targetDate: targetDate,
      );
}

class SavingsGoalModelAdapter extends TypeAdapter<SavingsGoalModel> {
  @override
  final int typeId = HiveTypeIds.savingsGoalModel;

  @override
  SavingsGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsGoalModel(
      id: fields[0] as String,
      title: fields[1] as String,
      targetAmount: fields[2] as double,
      currentAmount: fields[3] as double,
      createdAt: fields[4] as DateTime,
      iconKey: fields[5] as String,
      colorValue: fields[6] as int,
      targetDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsGoalModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.targetAmount)
      ..writeByte(3)
      ..write(obj.currentAmount)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.iconKey)
      ..writeByte(6)
      ..write(obj.colorValue)
      ..writeByte(7)
      ..write(obj.targetDate);
  }
}
