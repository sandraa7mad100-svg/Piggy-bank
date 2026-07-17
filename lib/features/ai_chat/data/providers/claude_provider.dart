import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'ai_provider.dart';

/// Anthropic Claude (Messages API) implementation.
class ClaudeAiProvider implements AiProvider {
  ClaudeAiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  String get name => 'claude';

  @override
  Future<String> generateReply({
    required String userMessage,
    required List<ChatMessageEntity> history,
    required FinancialSnapshot snapshot,
  }) async {
    try {
      final messages = [
        for (final m in history.takeLast(10))
          {'role': m.role == ChatRole.user ? 'user' : 'assistant', 'content': m.content},
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _dio.post(
        'https://api.anthropic.com/v1/messages',
        options: Options(headers: {
          'x-api-key': EnvConfig.claudeApiKey,
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        }),
        data: {
          'model': EnvConfig.aiModel,
          'system': '$kAiSystemPrompt\n\n${buildSnapshotContext(snapshot)}',
          'messages': messages,
          'max_tokens': 220,
        },
      );

      final content = response.data['content'][0]['text'] as String;
      return content.trim();
    } on DioException catch (e, st) {
      appLogger.e('Claude request failed', error: e, stackTrace: st);
      throw const AiException("Penny couldn't reach Claude right now.");
    }
  }
}

extension _TakeLast<T> on List<T> {
  List<T> takeLast(int n) => length <= n ? this : sublist(length - n);
}
