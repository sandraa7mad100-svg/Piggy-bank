import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/features/transactions/domain/entities/transaction_entity.dart';
import 'package:piggy_bank/features/transactions/presentation/widgets/transaction_tile.dart';

void main() {
  testWidgets('expense shows a minus sign and its title/category', (tester) async {
    final transaction = TransactionEntity(
      id: '1',
      title: 'Comic book',
      amount: 5.5,
      type: TransactionType.expense,
      category: TransactionCategory.books,
      date: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TransactionTile(transaction: transaction))),
    );

    expect(find.text('Comic book'), findsOneWidget);
    expect(find.textContaining('-\$5.50'), findsOneWidget);
  });

  testWidgets('income shows a plus sign', (tester) async {
    final transaction = TransactionEntity(
      id: '2',
      title: 'Allowance',
      amount: 10,
      type: TransactionType.income,
      category: TransactionCategory.allowance,
      date: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TransactionTile(transaction: transaction))),
    );

    expect(find.textContaining('+\$10.00'), findsOneWidget);
  });

  testWidgets('expense tagged as a want shows the "Want" badge', (tester) async {
    final transaction = TransactionEntity(
      id: '3',
      title: 'Toy',
      amount: 8,
      type: TransactionType.expense,
      category: TransactionCategory.toys,
      date: DateTime(2026, 1, 1),
      isNeed: false,
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TransactionTile(transaction: transaction))),
    );

    expect(find.text('Want'), findsOneWidget);
  });
}
