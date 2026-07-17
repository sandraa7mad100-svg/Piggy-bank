import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
    this.isNeed = false,
  });

  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? note;
  final bool isNeed;

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
        id: e.id,
        title: e.title,
        amount: e.amount,
        type: e.type,
        category: e.category,
        date: e.date,
        note: e.note,
        isNeed: e.isNeed,
      );

  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        title: title,
        amount: amount,
        type: type,
        category: category,
        date: date,
        note: note,
        isNeed: isNeed,
      );

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        amount: (json['amount'] as num).toDouble(),
        type: TransactionType.values[json['type'] as int],
        category: TransactionCategory.values[json['category'] as int],
        date: DateTime.parse(json['date'] as String),
        note: json['note'] as String?,
        isNeed: json['isNeed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'type': type.index,
        'category': category.index,
        'date': date.toIso8601String(),
        'note': note,
        'isNeed': isNeed,
      };
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = HiveTypeIds.transactionModel;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      type: fields[3] as TransactionType,
      category: fields[4] as TransactionCategory,
      date: fields[5] as DateTime,
      note: fields[6] as String?,
      isNeed: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.isNeed);
  }
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = HiveTypeIds.transactionType;

  @override
  TransactionType read(BinaryReader reader) => TransactionType.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, TransactionType obj) => writer.writeByte(obj.index);
}

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = HiveTypeIds.transactionCategory;

  @override
  TransactionCategory read(BinaryReader reader) => TransactionCategory.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, TransactionCategory obj) => writer.writeByte(obj.index);
}
