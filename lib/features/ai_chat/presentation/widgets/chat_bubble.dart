import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: context.screenSize.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: isUser
            ? AppColors.primaryGradient
            : (message.isMilestone ? AppColors.coinGradient : null),
        color: isUser || message.isMilestone ? null : (context.isDarkMode ? AppColors.surfaceDarkAlt : AppColors.surfaceLightAlt),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppSpacing.md),
          topRight: const Radius.circular(AppSpacing.md),
          bottomLeft: Radius.circular(isUser ? AppSpacing.md : AppSpacing.xs),
          bottomRight: Radius.circular(isUser ? AppSpacing.xs : AppSpacing.md),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.content,
            style: context.textTheme.bodyLarge?.copyWith(color: isUser || message.isMilestone ? Colors.white : null),
          ),
          const SizedBox(height: 4),
          Text(
            message.timestamp.toTime(),
            style: context.textTheme.labelSmall?.copyWith(
              color: (isUser || message.isMilestone) ? Colors.white70 : null,
            ),
          ),
        ],
      ),
    );

    final row = Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          const _PennyAvatar(),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(child: bubble),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: row,
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.15, end: 0, duration: 250.ms);
  }
}

class _PennyAvatar extends StatelessWidget {
  const _PennyAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(gradient: AppColors.aiGradient, shape: BoxShape.circle),
      child: const Icon(Icons.savings_rounded, color: Colors.white, size: 18),
    );
  }
}

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          const _PennyAvatar(),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.surfaceDarkAlt : AppColors.surfaceLightAlt,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.md),
                topRight: Radius.circular(AppSpacing.md),
                bottomRight: Radius.circular(AppSpacing.md),
                bottomLeft: Radius.circular(AppSpacing.xs),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.accentPurple, shape: BoxShape.circle),
                ).animate(onPlay: (c) => c.repeat()).fadeIn(delay: (i * 150).ms, duration: 400.ms).then().fadeOut(duration: 400.ms);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
