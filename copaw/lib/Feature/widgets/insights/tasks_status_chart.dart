import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';

class TasksStatusChart extends StatelessWidget {
  final Map<String, int> statusData;
  final int total;

  const TasksStatusChart({
    super.key,
    required this.statusData,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return Customcontainer(
        Width: double.infinity,
        Height: 280,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tasks available',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Customcontainer(
      Width: double.infinity,
      Height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tasks Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:AppColors.text,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: statusData['Done']!.toDouble(),
                          title: total > 0
                              ? '${((statusData['Done']! / total) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: Colors.green,
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: statusData['Doing']!.toDouble(),
                          title: total > 0
                              ? '${((statusData['Doing']! / total) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: Colors.orange,
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: statusData['To Do']!.toDouble(),
                          title: total > 0
                              ? '${((statusData['To Do']! / total) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: Colors.blue,
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(
                          color: Colors.green,
                          label: 'Done',
                          count: statusData['Done']!,
                        ),
                        const SizedBox(height: 12),
                        _LegendItem(
                          color: Colors.orange,
                          label: 'Doing',
                          count: statusData['Doing']!,
                        ),
                        const SizedBox(height: 12),
                        _LegendItem(
                          color: Colors.blue,
                          label: 'To Do',
                          count: statusData['To Do']!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
