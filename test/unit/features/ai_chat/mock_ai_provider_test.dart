import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/features/ai_chat/data/providers/mock_ai_provider.dart';
import 'package:piggy_bank/features/ai_chat/domain/entities/chat_message_entity.dart';

void main() {
  group('MockAiProvider', () {
    final provider = MockAiProvider();

    const snapshot = FinancialSnapshot(
      balance: 42,
      weeklySpending: 10,
      weeklyIncome: 20,
      topCategory: 'Toys',
      needsTotal: 6,
      wantsTotal: 4,
      activeGoalTitle: 'New bike',
      activeGoalProgress: 0.5,
    );

    test('explains needs vs wants when asked', () async {
      final reply = await provider.generateReply(
        userMessage: "what's the difference between needs and wants?",
        history: const [],
        snapshot: snapshot,
      );
      expect(reply.toLowerCase(), contains('need'));
      expect(reply.toLowerCase(), contains('want'));
    });

    test('references the active goal when asked about saving', () async {
      final reply = await provider.generateReply(
        userMessage: 'how is my saving goal going?',
        history: const [],
        snapshot: snapshot,
      );
      expect(reply, contains('New bike'));
      expect(reply, contains('50%'));
    });

    test('reports the current balance when asked', () async {
      final reply = await provider.generateReply(
        userMessage: 'how much money do i have?',
        history: const [],
        snapshot: snapshot,
      );
      expect(reply, contains('42.00'));
    });

    test('falls back to a generic prompt for unrelated input', () async {
      final reply = await provider.generateReply(
        userMessage: 'xyzzy plugh',
        history: const [],
        snapshot: snapshot,
      );
      expect(reply, isNotEmpty);
    });
  });
}
