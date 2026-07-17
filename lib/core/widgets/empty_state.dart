import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Friendly "nothing here yet" placeholder used across Transactions,
/// Goals, Notifications, and Search results.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(message, style: context.textTheme.bodyMedium, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
