import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

/// Spending/income categories tailored to kids, used by the category
/// breakdown chart and the transaction list/filter UI.
enum TransactionCategory {
  toys,
  games,
  snacks,
  clothes,
  books,
  charity,
  entertainment,
  savingsDeposit,
  allowance,
  gift,
  chores,
  other,
}

class TransactionEntity extends Equatable {
  const TransactionEntity({
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

  /// Only meaningful for [TransactionType.expense] — flags whether this
  /// was a "need" or a "want" so the AI assistant and Statistics screen can
  /// teach the needs-vs-wants distinction from real data.
  final bool isNeed;

  TransactionEntity copyWith({
    String? title,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    String? note,
    bool? isNeed,
  }) {
    return TransactionEntity(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      isNeed: isNeed ?? this.isNeed,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, type, category, date, note, isNeed];
}
