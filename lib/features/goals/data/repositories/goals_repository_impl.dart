import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/goals_local_data_source.dart';
import '../models/savings_goal_model.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  GoalsRepositoryImpl(this._local);

  final GoalsLocalDataSource _local;

  @override
  Future<Result<List<SavingsGoalEntity>>> getGoals() async {
    try {
      return Result.success(_local.getAll().map((m) => m.toEntity()).toList());
    } catch (e, st) {
      appLogger.e('getGoals failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure());
    }
  }

  @override
  Stream<List<SavingsGoalEntity>> watchGoals() {
    return _local.watchAll().map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<SavingsGoalEntity>> saveGoal(SavingsGoalEntity goal) async {
    try {
      await _local.save(SavingsGoalModel.fromEntity(goal));
      return Result.success(goal);
    } catch (e, st) {
      appLogger.e('saveGoal failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure('Could not save goal.'));
    }
  }

  @override
  Future<Result<SavingsGoalEntity>> contribute(String goalId, double amount) async {
    try {
      final existing = _local.getAll().where((g) => g.id == goalId).firstOrNull;
      if (existing == null) {
        return const Result.failure(NotFoundFailure('Goal not found.'));
      }
      final updated = existing.toEntity().copyWith(currentAmount: existing.currentAmount + amount);
      await _local.save(SavingsGoalModel.fromEntity(updated));
      return Result.success(updated);
    } catch (e, st) {
      appLogger.e('contribute failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure('Could not update goal.'));
    }
  }

  @override
  Future<Result<void>> deleteGoal(String id) async {
    try {
      await _local.delete(id);
      return const Result.success(null);
    } catch (e, st) {
      appLogger.e('deleteGoal failed', error: e, stackTrace: st);
      return const Result.failure(CacheFailure('Could not delete goal.'));
    }
  }
}
