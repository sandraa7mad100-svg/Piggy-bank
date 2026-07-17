import '../../domain/entities/chat_message_entity.dart';

/// Everything a concrete AI backend needs to implement. This is the seam
/// that lets OpenAI, Gemini, Claude, or a fully offline mock be swapped
/// via `.env`'s `AI_PROVIDER` without any change to the chat UI or
/// repository — see [AiProviderFactory].
abstract class AiProvider {
  String get name;

  Future<String> generateReply({
    required String userMessage,
    required List<ChatMessageEntity> history,
    required FinancialSnapshot snapshot,
  });
}

/// System persona shared by every real LLM-backed provider so the voice
/// stays consistent regardless of which model answers.
const String kAiSystemPrompt = '''
You are Penny, a friendly piggy-bank mascot and financial buddy for kids
aged 6-14 inside the "Piggy Bank" app. Your job:
- Explain money and spending in simple, encouraging language a child can understand.
- Encourage saving without being preachy; celebrate progress genuinely.
- Clearly explain the difference between "needs" (things that keep you safe,
  healthy, fed, or learning) and "wants" (things that are just for fun).
- Answer money questions honestly and simply — no jargon.
- Help the child think through a purchase decision instead of deciding for them.
- When given financial data (balance, weekly spending, goals), reference it
  specifically instead of speaking in generalities.
- Keep replies short (2-4 sentences), warm, and age-appropriate. Use at most
  one emoji per message. Never discuss topics unrelated to money, saving,
  spending, or the app itself — gently redirect back to the topic of saving
  and spending if asked.
''';

String buildSnapshotContext(FinancialSnapshot s) {
  final buffer = StringBuffer()
    ..writeln('Current piggy bank balance: \$${s.balance.toStringAsFixed(2)}')
    ..writeln('Spent this week: \$${s.weeklySpending.toStringAsFixed(2)}')
    ..writeln('Received this week: \$${s.weeklyIncome.toStringAsFixed(2)}')
    ..writeln('Needs vs wants this period: \$${s.needsTotal.toStringAsFixed(2)} needs, '
        '\$${s.wantsTotal.toStringAsFixed(2)} wants');
  if (s.topCategory != null) buffer.writeln('Top spending category: ${s.topCategory}');
  if (s.activeGoalTitle != null) {
    buffer.writeln(
      'Active savings goal: "${s.activeGoalTitle}" at ${(s.activeGoalProgress * 100).round()}% complete',
    );
  }
  return buffer.toString();
}
