import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/app_logger.dart';
import 'firebase_bootstrap.dart';

/// Requests push notification permission and exposes the device token so
/// it can be attached to the user's Firestore profile for targeted
/// milestone/reminder pushes. A no-op when Firebase isn't configured.
abstract final class MessagingService {
  static Future<void> init() async {
    if (!FirebaseBootstrap.isAvailable) return;

    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
    appLogger.i('Notification permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((message) {
      appLogger.i('Foreground FCM message: ${message.notification?.title}');
    });
  }

  static Future<String?> getToken() async {
    if (!FirebaseBootstrap.isAvailable) return null;
    return FirebaseMessaging.instance.getToken();
  }
}
