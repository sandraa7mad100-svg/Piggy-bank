import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_chat_local_data_source.dart';
import '../models/chat_message_model.dart';
import '../providers/ai_provider.dart';

class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl({required this._provider, required AiChatLocalDataSource localDataSource})
      : _local = localDataSource;

  final AiProvider _provider;
  final AiChatLocalDataSource _local;
  static const _uuid = Uuid();

  @override
  Stream<List<ChatMessageEntity>> watchMessages() {
    return _local.watchAll().map((models) => models.map((m) => m.toEntity()).toList());
  }

  Future<ChatMessageEntity> _persist(String content, {bool isMilestone = false}) async {
    final message = ChatMessageEntity(
      id: _uuid.v4(),
      content: content,
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
      isMilestone: isMilestone,
    );
    await _local.add(ChatMessageModel.fromEntity(message));
    return message;
  }

  @override
  Future<Result<ChatMessageEntity>> sendMessage({
    required String text,
    required FinancialSnapshot snapshot,
  }) async {
    try {
      final userMessage = ChatMessageEntity(
        id: _uuid.v4(),
        content: text,
        role: ChatRole.user,
        timestamp: DateTime.now(),
      );
      await _local.add(ChatMessageModel.fromEntity(userMessage));

      final history = _local.getAll().map((m) => m.toEntity()).toList();
      final reply = await _provider.generateReply(userMessage: text, history: history, snapshot: snapshot);
      final assistantMessage = await _persist(reply);
      return Result.success(assistantMessage);
    } on AiException catch (e) {
      return Result.failure(AiFailure(e.message));
    } catch (e, st) {
      appLogger.e('sendMessage failed', error: e, stackTrace: st);
      return const Result.failure(AiFailure());
    }
  }

  @override
  Future<Result<ChatMessageEntity>> generateWeeklySummary(FinancialSnapshot snapshot) async {
    try {
      final history = _local.getAll().map((m) => m.toEntity()).toList();
      final reply = await _provider.generateReply(
        userMessage: 'Give me my weekly spending summary.',
        history: history,
        snapshot: snapshot,
      );
      return Result.success(await _persist(reply));
    } catch (e, st) {
      appLogger.e('generateWeeklySummary failed', error: e, stackTrace: st);
      return const Result.failure(AiFailure());
    }
  }

  @override
  Future<Result<ChatMessageEntity>> celebrateMilestone(String milestoneDescription) async {
    try {
      return Result.success(
        await _persist('🎉 $milestoneDescription Keep up the awesome saving!', isMilestone: true),
      );
    } catch (e, st) {
      appLogger.e('celebrateMilestone failed', error: e, stackTrace: st);
      return const Result.failure(AiFailure());
    }
  }

  @override
  Future<void> clearHistory() => _local.clear();
}
