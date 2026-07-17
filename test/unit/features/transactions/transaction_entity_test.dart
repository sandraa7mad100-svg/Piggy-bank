import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/features/transactions/domain/entities/transaction_entity.dart';

TransactionEntity _makeTransaction({
  double amount = 10,
  TransactionType type = TransactionType.expense,
  bool isNeed = false,
}) {
  return TransactionEntity(
    id: '1',
    title: 'Toy car',
    amount: amount,
    type: type,
    category: TransactionCategory.toys,
    date: DateTime(2026, 1, 1),
    isNeed: isNeed,
  );
}

void main() {
  group('TransactionEntity', () {
    test('copyWith overrides only the given fields', () {
      final original = _makeTransaction();
      final updated = original.copyWith(amount: 25, isNeed: true);

      expect(updated.amount, 25);
      expect(updated.isNeed, isTrue);
      expect(updated.title, original.title);
      expect(updated.id, original.id);
      expect(updated.category, original.category);
    });

    test('equatable equality is based on field values, not identity', () {
      final a = _makeTransaction();
      final b = _makeTransaction();
      expect(a, equals(b));
    });

    test('inequality when a field differs', () {
      final a = _makeTransaction(amount: 10);
      final b = _makeTransaction(amount: 20);
      expect(a, isNot(equals(b)));
    });
  });
}
