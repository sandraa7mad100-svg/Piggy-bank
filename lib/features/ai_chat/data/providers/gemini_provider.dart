import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'ai_provider.dart';

/// Google Gemini (Generative Language API) implementation.
class GeminiAiProvider implements AiProvider {
  GeminiAiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  String get name => 'gemini';

  @override
  Future<String> generateReply({
    required String userMessage,
    required List<ChatMessageEntity> history,
    required FinancialSnapshot snapshot,
  }) async {
    try {
      final contents = [
        for (final m in history.takeLast(10))
          {
            'role': m.role == ChatRole.user ? 'user' : 'model',
            'parts': [
              {'text': m.content}
            ],
          },
        {
          'role': 'user',
          'parts': [
            {'text': userMessage}
          ],
        },
      ];

      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/${EnvConfig.aiModel}:generateContent',
        queryParameters: {'key': EnvConfig.geminiApiKey},
        data: {
          'systemInstruction': {
            'parts': [
              {'text': '$kAiSystemPrompt\n\n${buildSnapshotContext(snapshot)}'}
            ],
          },
          'contents': contents,
          'generationConfig': {'maxOutputTokens': 220, 'temperature': 0.6},
        },
      );

      final candidates = response.data['candidates'] as List;
      final text = candidates[0]['content']['parts'][0]['text'] as String;
      return text.trim();
    } on DioException catch (e, st) {
      appLogger.e('Gemini request failed', error: e, stackTrace: st);
      throw const AiException("Penny couldn't reach Gemini right now.");
    }
  }
}

extension _TakeLast<T> on List<T> {
  List<T> takeLast(int n) => length <= n ? this : sublist(length - n);
}
