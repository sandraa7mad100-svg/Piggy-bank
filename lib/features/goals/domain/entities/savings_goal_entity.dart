import 'package:equatable/equatable.dart';

class SavingsGoalEntity extends Equatable {
  const SavingsGoalEntity({
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

  double get progress => targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);
  bool get isCompleted => currentAmount >= targetAmount;

  SavingsGoalEntity copyWith({
    String? title,
    double? targetAmount,
    double? currentAmount,
    String? iconKey,
    int? colorValue,
    DateTime? targetDate,
  }) {
    return SavingsGoalEntity(
      id: id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      createdAt: createdAt,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, targetAmount, currentAmount, createdAt, iconKey, colorValue, targetDate];
}
