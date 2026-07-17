/// Central registry of Hive box names and typeIds so every feature reads
/// from a single source of truth instead of hardcoding strings/ids.
abstract final class HiveBoxes {
  static const String userProfile = 'box_user_profile';
  static const String transactions = 'box_transactions';
  static const String savingsGoals = 'box_savings_goals';
  static const String chatMessages = 'box_chat_messages';
  static const String achievements = 'box_achievements';
  static const String notifications = 'box_notifications';
  static const String appSettings = 'box_app_settings';
}

/// Hive `typeId`s for hand-written [TypeAdapter]s. Kept centralized and
/// documented so future adapters never collide.
abstract final class HiveTypeIds {
  static const int userModel = 0;
  static const int transactionModel = 1;
  static const int savingsGoalModel = 2;
  static const int chatMessageModel = 3;
  static const int achievementModel = 4;
  static const int notificationModel = 5;
  static const int transactionType = 6;
  static const int transactionCategory = 7;
  static const int chatRole = 8;
}
