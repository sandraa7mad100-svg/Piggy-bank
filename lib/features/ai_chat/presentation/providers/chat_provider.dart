import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../transactions/presentation/utils/category_ui.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/ai_repository.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) => getIt<AiRepository>());

final chatMessagesStreamProvider = StreamProvider<List<ChatMessageEntity>>((ref) {
  return ref.watch(aiRepositoryProvider).watchMessages();
});

/// Builds a fresh [FinancialSnapshot] from the live transactions/goals
/// providers so every AI reply is grounded in the child's actual data.
final financialSnapshotProvider = Provider<FinancialSnapshot>((ref) {
  final balance = ref.watch(balanceProvider);
  final weeklySpending = ref.watch(weeklySpendingProvider).fold<double>(0, (a, b) => a + b);
  final weeklyIncome = ref.watch(weeklyIncomeProvider);
  final breakdown = ref.watch(categoryBreakdownProvider);
  final needsWants = ref.watch(needsVsWantsProvider);
  final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];

  String? topCategory;
  if (breakdown.isNotEmpty) {
    final sorted = breakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    topCategory = sorted.first.key.label;
  }

  final activeGoal = goals.where((g) => !g.isCompleted).firstOrNull;

  return FinancialSnapshot(
    balance: balance,
    weeklySpending: weeklySpending,
    weeklyIncome: weeklyIncome,
    topCategory: topCategory,
    needsTotal: needsWants.needs,
    wantsTotal: needsWants.wants,
    activeGoalTitle: activeGoal?.title,
    activeGoalProgress: activeGoal?.progress ?? 0,
  );
});

class ChatController extends StateNotifier<AsyncValue<void>> {
  ChatController(this._repository, this._ref) : super(const AsyncValue.data(null));

  final AiRepository _repository;
  final Ref _ref;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    state = const AsyncValue.loading();
    final snapshot = _ref.read(financialSnapshotProvider);
    final result = await _repository.sendMessage(text: text.trim(), snapshot: snapshot);
    state = result.when(
      success: (_) {
        getIt<AnalyticsService>().logAiMessageSent();
        return const AsyncValue.data(null);
      },
      failure: (f) => AsyncValue.error(f.message, StackTrace.current),
    );
  }

  Future<void> requestWeeklySummary() async {
    final snapshot = _ref.read(financialSnapshotProvider);
    await _repository.generateWeeklySummary(snapshot);
  }
}

final chatControllerProvider = StateNotifierProvider<ChatController, AsyncValue<void>>((ref) {
  return ChatController(ref.watch(aiRepositoryProvider), ref);
});
