import 'package:hive_flutter/hive_flutter.dart';

import '../../features/ai_chat/data/models/chat_message_model.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/goals/data/models/savings_goal_model.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../constants/hive_boxes.dart';

/// Initializes Hive, registers every hand-written [TypeAdapter], and opens
/// all boxes up front so repositories can assume `Hive.box(...)` is ready
/// once [HiveService.init] has completed (called once in `main.dart`).
///
/// Adapters are hand-written (not code-generated) — see each model's
/// `*_model.dart` for its adapter — to avoid a build_runner step blocking
/// iteration speed. Behavior is identical to generated adapters.
abstract final class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(TransactionCategoryAdapter());
    Hive.registerAdapter(SavingsGoalModelAdapter());
    Hive.registerAdapter(ChatMessageModelAdapter());
    Hive.registerAdapter(ChatRoleAdapter());
    Hive.registerAdapter(NotificationModelAdapter());

    await Future.wait([
      Hive.openBox<UserModel>(HiveBoxes.userProfile),
      Hive.openBox<TransactionModel>(HiveBoxes.transactions),
      Hive.openBox<SavingsGoalModel>(HiveBoxes.savingsGoals),
      Hive.openBox<ChatMessageModel>(HiveBoxes.chatMessages),
      Hive.openBox<NotificationModel>(HiveBoxes.notifications),
      Hive.openBox(HiveBoxes.appSettings),
    ]);
  }
}
