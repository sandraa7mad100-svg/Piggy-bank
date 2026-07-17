import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/features/goals/domain/entities/savings_goal_entity.dart';

void main() {
  group('SavingsGoalEntity', () {
    test('progress is currentAmount / targetAmount', () {
      final goal = SavingsGoalEntity(
        id: '1',
        title: 'Bike',
        targetAmount: 100,
        currentAmount: 25,
        createdAt: DateTime(2026, 1, 1),
      );
      expect(goal.progress, 0.25);
      expect(goal.isCompleted, isFalse);
    });

    test('progress clamps at 1.0 even if overfunded', () {
      final goal = SavingsGoalEntity(
        id: '1',
        title: 'Bike',
        targetAmount: 100,
        currentAmount: 150,
        createdAt: DateTime(2026, 1, 1),
      );
      expect(goal.progress, 1.0);
      expect(goal.isCompleted, isTrue);
    });

    test('progress is 0 when targetAmount is 0 (avoids division by zero)', () {
      final goal = SavingsGoalEntity(
        id: '1',
        title: 'Bike',
        targetAmount: 0,
        currentAmount: 0,
        createdAt: DateTime(2026, 1, 1),
      );
      expect(goal.progress, 0);
    });

    test('copyWith only changes provided fields', () {
      final goal = SavingsGoalEntity(
        id: '1',
        title: 'Bike',
        targetAmount: 100,
        currentAmount: 25,
        createdAt: DateTime(2026, 1, 1),
      );
      final updated = goal.copyWith(currentAmount: 50);
      expect(updated.currentAmount, 50);
      expect(updated.title, 'Bike');
      expect(updated.targetAmount, 100);
    });
  });
}
