import 'package:hive/hive.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../models/chat_message_model.dart';

class AiChatLocalDataSource {
  Box<ChatMessageModel> get _box => Hive.box<ChatMessageModel>(HiveBoxes.chatMessages);

  List<ChatMessageModel> getAll() {
    final items = _box.values.toList();
    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return items;
  }

  Stream<List<ChatMessageModel>> watchAll() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }

  Future<void> add(ChatMessageModel model) => _box.put(model.id, model);

  Future<void> clear() => _box.clear();
}
