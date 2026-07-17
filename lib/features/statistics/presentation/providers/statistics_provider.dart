import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';

/// Cumulative balance after each transaction, oldest first — the data
/// behind the "Savings progress" line chart.
final savingsProgressProvider = Provider<List<double>>((ref) {
  final transactions = List<TransactionEntity>.from(
    ref.watch(transactionsStreamProvider).valueOrNull ?? const [],
  )..sort((a, b) => a.date.compareTo(b.date));

  double running = 0;
  final points = <double>[];
  for (final t in transactions) {
    running += t.type == TransactionType.income ? t.amount : -t.amount;
    points.add(running);
  }
  return points;
});

/// Total expenses per month for the last 6 months, oldest first.
final monthlySpendingProvider = Provider<List<MapEntry<String, double>>>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).valueOrNull ?? const [];
  final now = DateTime.now();
  const monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final months = List.generate(6, (i) {
    final date = DateTime(now.year, now.month - (5 - i));
    return DateTime(date.year, date.month);
  });

  final totals = {for (final m in months) m: 0.0};
  for (final t in transactions.where((t) => t.type == TransactionType.expense)) {
    final key = DateTime(t.date.year, t.date.month);
    if (totals.containsKey(key)) totals[key] = totals[key]! + t.amount;
  }

  return months.map((m) => MapEntry(monthLabels[m.month - 1], totals[m]!)).toList();
});
