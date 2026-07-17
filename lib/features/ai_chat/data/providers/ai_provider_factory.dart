import '../../../../core/config/env_config.dart';
import 'ai_provider.dart';
import 'claude_provider.dart';
import 'gemini_provider.dart';
import 'mock_ai_provider.dart';
import 'openai_provider.dart';

/// Picks the concrete [AiProvider] based on `.env`'s `AI_PROVIDER`, falling
/// back to [MockAiProvider] whenever the selected provider is missing its
/// API key — this is what keeps the AI Chat screen fully usable with zero
/// configuration.
abstract final class AiProviderFactory {
  static AiProvider create() {
    if (!EnvConfig.hasAiCredentials) return MockAiProvider();

    return switch (EnvConfig.aiProvider) {
      'openai' => OpenAiProvider(),
      'gemini' => GeminiAiProvider(),
      'claude' => ClaudeAiProvider(),
      _ => MockAiProvider(),
    };
  }
}
