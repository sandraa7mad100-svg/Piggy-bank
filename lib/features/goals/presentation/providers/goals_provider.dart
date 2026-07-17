import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../ai_chat/domain/repositories/ai_repository.dart';
import '../../../notifications/domain/notification_entity.dart';
import '../../../notifications/domain/notifications_repository.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) => getIt<GoalsRepository>());

final goalsStreamProvider = StreamProvider<List<SavingsGoalEntity>>((ref) {
  return ref.watch(goalsRepositoryProvider).watchGoals();
});

class GoalsController extends StateNotifier<AsyncValue<void>> {
  GoalsController(this._repository) : super(const AsyncValue.data(null));

  final GoalsRepository _repository;
  static const _uuid = Uuid();

  Future<bool> createGoal({
    required String title,
    required double targetAmount,
    String iconKey = 'toys',
    int colorValue = 0xFFFF6B9D,
    DateTime? targetDate,
  }) async {
    state = const AsyncValue.loading();
    final goal = SavingsGoalEntity(
      id: _uuid.v4(),
      title: title,
      targetAmount: targetAmount,
      currentAmount: 0,
      createdAt: DateTime.now(),
      iconKey: iconKey,
      colorValue: colorValue,
      targetDate: targetDate,
    );
    final result = await _repository.saveGoal(goal);
    state = const AsyncValue.data(null);
    if (result.isSuccess) {
      getIt<AnalyticsService>().logGoalCreated(title);
    }
    return result.isSuccess;
  }

  Future<bool> contribute(String goalId, double amount) async {
    final result = await _repository.contribute(goalId, amount);
    final updated = result.dataOrNull;
    if (updated != null && updated.isCompleted) {
      getIt<AnalyticsService>().logGoalCompleted(updated.title);
      await getIt<NotificationsRepository>().add(
        NotificationEntity(
          id: _uuid.v4(),
          title: 'Goal reached! 🎉',
          body: 'You hit your "${updated.title}" savings goal!',
          timestamp: DateTime.now(),
          kind: NotificationKind.milestone,
        ),
      );
      await getIt<AiRepository>().celebrateMilestone('You just reached your "${updated.title}" savings goal!');
    }
    return result.isSuccess;
  }

  Future<void> deleteGoal(String id) => _repository.deleteGoal(id);
}

final goalsControllerProvider = StateNotifierProvider<GoalsController, AsyncValue<void>>((ref) {
  return GoalsController(ref.watch(goalsRepositoryProvider));
});
