import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../utils/app_logger.dart';

/// Attempts to initialize Firebase once at startup and remembers whether it
/// actually succeeded.
///
/// The shipped `firebase_options.dart` contains placeholder values until a
/// real project is wired up via `flutterfire configure` (see README). When
/// initialization fails — no real project, no network, placeholder keys —
/// [isAvailable] stays `false` and every repository that talks to Firebase
/// falls back to a local/offline implementation instead of crashing the
/// app. This is what lets "Every screen must be functional" hold true even
/// before a backend is configured.
abstract final class FirebaseBootstrap {
  static bool _isAvailable = false;
  static bool get isAvailable => _isAvailable;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      _isAvailable = true;
      appLogger.i('Firebase initialized');
    } catch (e, st) {
      _isAvailable = false;
      appLogger.w('Firebase unavailable, falling back to offline/local mode', error: e, stackTrace: st);
    }
  }
}
