import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../models/transaction_model.dart';

/// Transactions are offline-first by design (an allowance app should never
/// lose a kid's data because of a flaky connection), so Hive is the single
/// source of truth here. A Firestore sync layer can be added later behind
/// the same [TransactionRepository] interface without touching the UI.
class TransactionLocalDataSource {
  Box<TransactionModel> get _box => Hive.box<TransactionModel>(HiveBoxes.transactions);

  List<TransactionModel> getAll() {
    final items = _box.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  /// Emits the current snapshot immediately, then again on every box write.
  Stream<List<TransactionModel>> watchAll() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }

  Future<void> add(TransactionModel model) => _box.put(model.id, model);

  Future<void> update(TransactionModel model) => _box.put(model.id, model);

  Future<void> delete(String id) => _box.delete(id);
}
