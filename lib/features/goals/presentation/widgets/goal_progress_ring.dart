import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Ring showing "goal completion" progress via `fl_chart`'s [PieChart] —
/// two sections (filled / remaining) rendered as a donut.
class GoalProgressRing extends StatelessWidget {
  const GoalProgressRing({super.key, required this.progress, required this.color, this.size = 64, this.child});

  final double progress;
  final Color color;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: size / 2 - 8,
              sections: [
                PieChartSectionData(value: clamped, color: color, radius: 8, showTitle: false),
                PieChartSectionData(
                  value: 1 - clamped,
                  color: AppColors.borderLight,
                  radius: 8,
                  showTitle: false,
                ),
              ],
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}
