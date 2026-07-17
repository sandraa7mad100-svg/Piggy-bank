import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Standard pill-shaped call-to-action button with a built-in loading
/// state and light haptic feedback on tap, used for every primary action
/// across auth, transactions, and goals.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = true,
    this.color = AppColors.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expand;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading || onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
      style: ElevatedButton.styleFrom(backgroundColor: color, disabledBackgroundColor: color.withValues(alpha: 0.6)),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: AppSpacing.sm)],
                Text(label),
              ],
            ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
