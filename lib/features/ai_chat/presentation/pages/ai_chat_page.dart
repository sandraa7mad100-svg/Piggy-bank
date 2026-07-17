import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/suggestion_chips.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(String text) async {
    await ref.read(chatControllerProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesStreamProvider);
    final chatState = ref.watch(chatControllerProvider);
    final isSending = chatState.isLoading;

    ref.listen(chatMessagesStreamProvider, (_, _) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(gradient: AppColors.aiGradient, shape: BoxShape.circle),
              child: const Icon(Icons.savings_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Penny · AI Buddy'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize_rounded),
            tooltip: 'Weekly summary',
            onPressed: () => ref.read(chatControllerProvider.notifier).requestWeeklySummary(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load chat: $e')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Say hi to Penny!',
                    message: 'Ask about saving, spending, or your goals — Penny is here to help.',
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: messages.length + (isSending ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == messages.length) return const TypingBubble();
                    return ChatBubble(message: messages[i]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SuggestionChips(onSelected: _send),
          ),
          const SizedBox(height: AppSpacing.sm),
          ChatInput(onSend: _send, enabled: !isSending),
        ],
      ),
    );
  }
}
