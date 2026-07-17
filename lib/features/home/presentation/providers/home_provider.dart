import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/presentation/providers/transaction_provider.dart';

/// income - expense for the last 7 days, used as the "+/- this week" chip
/// on the balance card.
final weeklyNetDeltaProvider = Provider<double>((ref) {
  final weeklySpending = ref.watch(weeklySpendingProvider).fold<double>(0, (a, b) => a + b);
  final weeklyIncome = ref.watch(weeklyIncomeProvider);
  return weeklyIncome - weeklySpending;
});
