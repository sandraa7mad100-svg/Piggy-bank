import 'package:flutter/material.dart';

import '../extensions/num_extensions.dart';

/// Animates the displayed balance counting up/down to [value] whenever it
/// changes, instead of snapping — makes deposits/withdrawals feel alive on
/// the Home screen.
class AnimatedBalanceCounter extends StatelessWidget {
  const AnimatedBalanceCounter({super.key, required this.value, required this.style, this.duration = const Duration(milliseconds: 900)});

  final double value;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Text(animatedValue.toCurrency(), style: style);
      },
    );
  }
}
