import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'ai_provider.dart';

/// OpenAI Chat Completions implementation. Swappable 1:1 with
/// [GeminiAiProvider] / [ClaudeAiProvider] behind the [AiProvider]
/// interface — see [AiProviderFactory].
class OpenAiProvider implements AiProvider {
  OpenAiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  String get name => 'openai';

  @override
  Future<String> generateReply({
    required String userMessage,
    required List<ChatMessageEntity> history,
    required FinancialSnapshot snapshot,
  }) async {
    try {
      final messages = [
        {'role': 'system', 'content': '$kAiSystemPrompt\n\n${buildSnapshotContext(snapshot)}'},
        for (final m in history.takeLast(10))
          {'role': m.role == ChatRole.user ? 'user' : 'assistant', 'content': m.content},
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(headers: {
          'Authorization': 'Bearer ${EnvConfig.openAiApiKey}',
          'Content-Type': 'application/json',
        }),
        data: {
          'model': EnvConfig.aiModel,
          'messages': messages,
          'max_tokens': 220,
          'temperature': 0.6,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;
      return content.trim();
    } on DioException catch (e, st) {
      appLogger.e('OpenAI request failed', error: e, stackTrace: st);
      throw const AiException("Penny couldn't reach OpenAI right now.");
    }
  }
}

extension _TakeLast<T> on List<T> {
  List<T> takeLast(int n) => length <= n ? this : sublist(length - n);
}
