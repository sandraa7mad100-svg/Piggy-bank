import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to `.env` values (loaded via `flutter_dotenv` in `main.dart`
/// before `runApp`). Nothing secret is ever hardcoded in source — see
/// `.env.example` for the full list of keys a deployer must provide.
///
/// All getters fail soft (return null/empty) rather than throwing, so the
/// app remains usable in demo/offline mode when keys haven't been
/// configured yet (e.g. no Firebase project or AI key set up).
abstract final class EnvConfig {
  static String? _get(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static bool get isConfigured => dotenv.isInitialized;

  // AI provider
  static String get aiProvider => _get('AI_PROVIDER') ?? 'mock';
  static String? get openAiApiKey => _get('OPENAI_API_KEY');
  static String? get geminiApiKey => _get('GEMINI_API_KEY');
  static String? get claudeApiKey => _get('CLAUDE_API_KEY');
  static String get aiModel => _get('AI_MODEL') ?? 'gpt-4o-mini';

  // API base (for any custom backend / cloud functions)
  static String? get apiBaseUrl => _get('API_BASE_URL');

  // Feature flags
  static bool get useFirebaseEmulator => (_get('USE_FIREBASE_EMULATOR') ?? 'false') == 'true';

  static bool get hasAiCredentials {
    switch (aiProvider) {
      case 'openai':
        return openAiApiKey != null;
      case 'gemini':
        return geminiApiKey != null;
      case 'claude':
        return claudeApiKey != null;
      default:
        return false;
    }
  }
}
