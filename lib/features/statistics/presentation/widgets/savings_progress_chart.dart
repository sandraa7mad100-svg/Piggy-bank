import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Line chart of the running balance over time — "is my piggy bank
/// growing?" at a glance.
class SavingsProgressChart extends StatelessWidget {
  const SavingsProgressChart({super.key, required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Add a few transactions to see your savings trend.')),
      );
    }

    final spots = [for (int i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i])];
    final minY = points.reduce((a, b) => a < b ? a : b);
    final maxY = points.reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY).abs() * 0.2).clamp(1, double.infinity);

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineTouchData: const LineTouchData(enabled: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.secondary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: AppColors.secondary.withValues(alpha: 0.15)),
            ),
          ],
        ),
      ),
    );
  }
}
