import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class MonthlySpendingChart extends StatelessWidget {
  const MonthlySpendingChart({super.key, required this.monthlyTotals});

  final List<MapEntry<String, double>> monthlyTotals;

  @override
  Widget build(BuildContext context) {
    final maxY = monthlyTotals.map((e) => e.value).fold<double>(0, (a, b) => a > b ? a : b);
    final chartMax = maxY <= 0 ? 10.0 : maxY * 1.3;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: chartMax,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= monthlyTotals.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(monthlyTotals[index].key, style: context.textTheme.bodySmall),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < monthlyTotals.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: monthlyTotals[i].value,
                    color: AppColors.accentBlue,
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
