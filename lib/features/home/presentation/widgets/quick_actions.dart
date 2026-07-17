import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class QuickAction {
  const QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key, required this.actions});

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [for (final a in actions) _QuickActionButton(action: a)],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.action});
  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: action.color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(action.icon, color: action.color),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(action.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
