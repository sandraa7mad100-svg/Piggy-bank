import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSend, this.enabled = true});

  final ValueChanged<String> onSend;
  final bool enabled;

  @override
  State<ChatInput> createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();

  void setText(String text) => _controller.text = text;

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(hintText: 'Ask Penny anything about money...'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              decoration: const BoxDecoration(gradient: AppColors.aiGradient, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: widget.enabled ? _submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
