import '../../../../core/utils/result.dart';
import '../entities/chat_message_entity.dart';

abstract class AiRepository {
  Stream<List<ChatMessageEntity>> watchMessages();

  Future<Result<ChatMessageEntity>> sendMessage({
    required String text,
    required FinancialSnapshot snapshot,
  });

  /// Proactively generates a weekly summary + needs-vs-wants breakdown,
  /// shown as an assistant message without the child having to ask.
  Future<Result<ChatMessageEntity>> generateWeeklySummary(FinancialSnapshot snapshot);

  /// Called when a goal/savings milestone is reached; posts a celebratory
  /// assistant message into the chat.
  Future<Result<ChatMessageEntity>> celebrateMilestone(String milestoneDescription);

  Future<void> clearHistory();
}
