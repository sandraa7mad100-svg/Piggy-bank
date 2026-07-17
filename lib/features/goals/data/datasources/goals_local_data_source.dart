import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../models/savings_goal_model.dart';

class GoalsLocalDataSource {
  Box<SavingsGoalModel> get _box => Hive.box<SavingsGoalModel>(HiveBoxes.savingsGoals);

  List<SavingsGoalModel> getAll() {
    final items = _box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Stream<List<SavingsGoalModel>> watchAll() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }

  Future<void> save(SavingsGoalModel model) => _box.put(model.id, model);

  Future<void> delete(String id) => _box.delete(id);
}
