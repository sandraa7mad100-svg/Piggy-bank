import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._local);

  final TransactionLocalDataSource _local;

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() async {
    try {
      final entities = _local.getAll().map((m) => m.toEntity()).toList();
      return Result.success(entities);
    } catch (e, st) {
      appLogger.e('getTransactions failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure());
    }
  }

  @override
  Future<Result<TransactionEntity>> addTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await _local.add(model);
      return Result.success(transaction);
    } catch (e, st) {
      appLogger.e('addTransaction failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure('Could not save transaction.'));
    }
  }

  @override
  Future<Result<TransactionEntity>> updateTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await _local.update(model);
      return Result.success(transaction);
    } catch (e, st) {
      appLogger.e('updateTransaction failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure('Could not update transaction.'));
    }
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    try {
      await _local.delete(id);
      return const Result.success(null);
    } catch (e, st) {
      appLogger.e('deleteTransaction failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure('Could not delete transaction.'));
    }
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions() {
    return _local.watchAll().map((models) => models.map((m) => m.toEntity()).toList());
  }
}
