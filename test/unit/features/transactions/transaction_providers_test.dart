import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/core/utils/result.dart';
import 'package:piggy_bank/features/transactions/domain/entities/transaction_entity.dart';
import 'package:piggy_bank/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:piggy_bank/features/transactions/presentation/providers/transaction_provider.dart';

/// In-memory fake so provider logic (balance, weekly totals, category
/// breakdown, needs-vs-wants) can be tested without touching Hive.
class FakeTransactionRepository implements TransactionRepository {
  final _transactions = <TransactionEntity>[];
  final _controller = StreamController<List<TransactionEntity>>.broadcast();

  void seed(List<TransactionEntity> items) {
    _transactions
      ..clear()
      ..addAll(items);
    _controller.add(List.unmodifiable(_transactions));
  }

  @override
  Future<Result<TransactionEntity>> addTransaction(TransactionEntity transaction) async {
    _transactions.add(transaction);
    _controller.add(List.unmodifiable(_transactions));
    return Result.success(transaction);
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    _controller.add(List.unmodifiable(_transactions));
    return const Result.success(null);
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() async => Result.success(_transactions);

  @override
  Future<Result<TransactionEntity>> updateTransaction(TransactionEntity transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) _transactions[index] = transaction;
    _controller.add(List.unmodifiable(_transactions));
    return Result.success(transaction);
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions() => _controller.stream;
}

void main() {
  late FakeTransactionRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeTransactionRepository();
    container = ProviderContainer(
      overrides: [transactionRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);
  });

  TransactionEntity tx({
    required double amount,
    required TransactionType type,
    TransactionCategory category = TransactionCategory.toys,
    bool isNeed = false,
    DateTime? date,
  }) {
    return TransactionEntity(
      id: '${amount}_${type.name}_${category.name}_${isNeed}_${date?.millisecondsSinceEpoch}',
      title: 'test',
      amount: amount,
      type: type,
      category: category,
      date: date ?? DateTime.now(),
      isNeed: isNeed,
    );
  }

  test('balanceProvider nets income minus expense', () async {
    // Subscribe before seeding: FakeTransactionRepository uses a broadcast
    // stream with no replay, so events emitted before anyone is listening
    // would otherwise be lost — same as subscribing to a real Firestore
    // snapshot stream after it starts emitting.
    container.listen(transactionsStreamProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    fakeRepo.seed([
      tx(amount: 20, type: TransactionType.income),
      tx(amount: 5, type: TransactionType.expense),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(balanceProvider), 15);
  });

  test('needsVsWantsProvider splits expenses by isNeed', () async {
    container.listen(transactionsStreamProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    fakeRepo.seed([
      tx(amount: 10, type: TransactionType.expense, isNeed: true),
      tx(amount: 4, type: TransactionType.expense, isNeed: false),
      tx(amount: 100, type: TransactionType.income), // ignored, not an expense
    ]);
    await Future<void>.delayed(Duration.zero);

    final result = container.read(needsVsWantsProvider);
    expect(result.needs, 10);
    expect(result.wants, 4);
  });

  test('categoryBreakdownProvider sums expenses per category', () async {
    container.listen(transactionsStreamProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    fakeRepo.seed([
      tx(amount: 3, type: TransactionType.expense, category: TransactionCategory.snacks),
      tx(amount: 7, type: TransactionType.expense, category: TransactionCategory.snacks),
      tx(amount: 5, type: TransactionType.expense, category: TransactionCategory.toys),
    ]);
    await Future<void>.delayed(Duration.zero);

    final breakdown = container.read(categoryBreakdownProvider);
    expect(breakdown[TransactionCategory.snacks], 10);
    expect(breakdown[TransactionCategory.toys], 5);
  });
}
