import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
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

  /// True for a special celebratory message (goal reached, savings streak)
  /// so the chat bubble can render confetti styling instead of plain text.
  final bool isMilestone;

  @override
  List<Object?> get props => [id, content, role, timestamp, isMilestone];
}

/// A read-only snapshot of the child's finances, built fresh from the
/// Transactions/Goals repositories on every message send, so the assistant
/// (mock or real) can ground its answer in actual data instead of
/// hallucinating numbers.
class FinancialSnapshot {
  const FinancialSnapshot({
    required this.balance,
    required this.weeklySpending,
    required this.weeklyIncome,
    required this.topCategory,
    required this.needsTotal,
    required this.wantsTotal,
    required this.activeGoalTitle,
    required this.activeGoalProgress,
  });

  final double balance;
  final double weeklySpending;
  final double weeklyIncome;
  final String? topCategory;
  final double needsTotal;
  final double wantsTotal;
  final String? activeGoalTitle;
  final double activeGoalProgress;

  static const empty = FinancialSnapshot(
    balance: 0,
    weeklySpending: 0,
    weeklyIncome: 0,
    topCategory: null,
    needsTotal: 0,
    wantsTotal: 0,
    activeGoalTitle: null,
    activeGoalProgress: 0,
  );
}
