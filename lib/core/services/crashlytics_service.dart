import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'firebase_bootstrap.dart';

/// Wires uncaught Flutter/Dart errors to Crashlytics. No-ops entirely when
/// Firebase isn't configured (local/offline mode) — errors still surface
/// via [FlutterError.onError]'s default console output.
abstract final class CrashlyticsService {
  static Future<void> init() async {
    if (!FirebaseBootstrap.isAvailable) return;

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void recordError(Object error, StackTrace? stack, {String? reason}) {
    if (!FirebaseBootstrap.isAvailable) return;
    FirebaseCrashlytics.instance.recordError(error, stack, reason: reason);
  }

  static void setUserId(String id) {
    if (!FirebaseBootstrap.isAvailable) return;
    FirebaseCrashlytics.instance.setUserIdentifier(id);
  }
}
