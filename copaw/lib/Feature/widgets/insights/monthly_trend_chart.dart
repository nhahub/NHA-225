import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/utils/app_colors.dart';

class MonthlyTrendChart extends StatelessWidget {
  final List<int> monthlyData;

  const MonthlyTrendChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final maxValue = monthlyData.isEmpty
        ? 1
        : monthlyData.reduce((a, b) => a > b ? a : b);

    // Get month names for the last 6 months
    final now = DateTime.now();
    final List<String> monthLabels = [];
    final List<String> allMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      monthLabels.add(allMonths[monthDate.month - 1]);
    }

    return Customcontainer(
      Width: double.infinity,
      Height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '6-Month Completion Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < monthLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                monthLabels[index],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() == 0) return const SizedBox();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppColors.mainColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.mainColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
