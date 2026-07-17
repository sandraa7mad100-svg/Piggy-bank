import 'dart:math';

import '../../domain/entities/chat_message_entity.dart';
import 'ai_provider.dart';

/// Fully offline, rule-based provider used whenever no real AI API key is
/// configured (the default out of the box). It still gives genuinely
/// grounded, varied answers by reading the [FinancialSnapshot] — it's a
/// real fallback, not a "coming soon" stub.
class MockAiProvider implements AiProvider {
  final _random = Random();

  @override
  String get name => 'mock';

  @override
  Future<String> generateReply({
    required String userMessage,
    required List<ChatMessageEntity> history,
    required FinancialSnapshot snapshot,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final text = userMessage.toLowerCase();

    if (_matches(text, ['need', 'want', 'difference'])) {
      return "Great question! A *need* is something that keeps you safe, healthy, fed, "
          "or helps you learn — like school supplies. A *want* is just for fun, like a new "
          "toy or game. Right now you've spent \$${snapshot.needsTotal.toStringAsFixed(2)} on "
          "needs and \$${snapshot.wantsTotal.toStringAsFixed(2)} on wants. Both are okay — "
          "just try to cover needs first! 🌱";
    }
    if (_matches(text, ['save', 'saving', 'goal'])) {
      if (snapshot.activeGoalTitle != null) {
        final pct = (snapshot.activeGoalProgress * 100).round();
        return "You're $pct% of the way to \"${snapshot.activeGoalTitle}\"! Keep adding a little "
            "bit each week and you'll get there before you know it. 🐷";
      }
      return "Saving is like planting a seed for something bigger later! Try setting a savings "
          "goal on the Goals tab — even small amounts add up fast.";
    }
    if (_matches(text, ['summary', 'week', 'spending', 'spent'])) {
      return _weeklySummaryText(snapshot);
    }
    if (_matches(text, ['balance', 'how much', 'money do i have'])) {
      return "Your piggy bank balance right now is \$${snapshot.balance.toStringAsFixed(2)}. "
          "Nice work building that up! 🐷";
    }
    if (_matches(text, ['buy', 'purchase', 'should i'])) {
      return "Before buying, ask yourself: is it a need or a want? Can I afford it without "
          "touching my savings goal? If yes to both, it might be a smart buy!";
    }
    if (_matches(text, ['hi', 'hello', 'hey'])) {
      return "Hi there! I'm Penny 🐷 — ask me anything about saving, spending, or your goals!";
    }

    final fallbacks = [
      "That's a great money question! Could you tell me a bit more?",
      "I love talking about saving and spending — what would you like to know?",
      "Hmm, let's think about that together. Is it about saving, spending, or a goal?",
    ];
    return fallbacks[_random.nextInt(fallbacks.length)];
  }

  bool _matches(String text, List<String> keywords) => keywords.any(text.contains);

  String _weeklySummaryText(FinancialSnapshot s) {
    final net = s.weeklyIncome - s.weeklySpending;
    final trend = net >= 0 ? "You saved more than you spent this week — awesome! 🎉" : "You spent a bit more than you earned this week — let's watch that next week.";
    final category = s.topCategory != null ? " Most of your spending went to ${s.topCategory}." : '';
    return "This week: \$${s.weeklyIncome.toStringAsFixed(2)} in, \$${s.weeklySpending.toStringAsFixed(2)} out.$category $trend";
  }
}
