import '../../../../core/utils/result.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Result<List<TransactionEntity>>> getTransactions();
  Future<Result<TransactionEntity>> addTransaction(TransactionEntity transaction);
  Future<Result<TransactionEntity>> updateTransaction(TransactionEntity transaction);
  Future<Result<void>> deleteTransaction(String id);

  /// Live balance = sum(income) - sum(expense) across all cached transactions.
  Stream<List<TransactionEntity>> watchTransactions();
}
