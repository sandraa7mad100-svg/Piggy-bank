import 'package:firebase_analytics/firebase_analytics.dart';

import 'firebase_bootstrap.dart';

/// Thin wrapper over Firebase Analytics. Every call is a no-op when
/// Firebase isn't configured, so feature code never needs to check
/// [FirebaseBootstrap.isAvailable] itself.
class AnalyticsService {
  FirebaseAnalytics? get _instance => FirebaseBootstrap.isAvailable ? FirebaseAnalytics.instance : null;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _instance?.logEvent(name: name, parameters: parameters);
  }

  Future<void> logLogin(String method) => logEvent('login', parameters: {'method': method});

  Future<void> logSignUp(String method) => logEvent('sign_up', parameters: {'method': method});

  Future<void> logTransactionAdded({required String type, required double amount}) =>
      logEvent('transaction_added', parameters: {'type': type, 'amount': amount});

  Future<void> logGoalCreated(String title) => logEvent('goal_created', parameters: {'title': title});

  Future<void> logGoalCompleted(String title) => logEvent('goal_completed', parameters: {'title': title});

  Future<void> logAiMessageSent() => logEvent('ai_message_sent');

  Future<void> setUserId(String? id) async => _instance?.setUserId(id: id);

  Future<void> logScreenView(String screenName) => logEvent('screen_view', parameters: {'screen_name': screenName});
}
