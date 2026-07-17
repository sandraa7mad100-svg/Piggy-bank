import '../../../../core/utils/result.dart';
import '../entities/savings_goal_entity.dart';

abstract class GoalsRepository {
  Future<Result<List<SavingsGoalEntity>>> getGoals();
  Stream<List<SavingsGoalEntity>> watchGoals();
  Future<Result<SavingsGoalEntity>> saveGoal(SavingsGoalEntity goal);
  Future<Result<SavingsGoalEntity>> contribute(String goalId, double amount);
  Future<Result<void>> deleteGoal(String id);
}
