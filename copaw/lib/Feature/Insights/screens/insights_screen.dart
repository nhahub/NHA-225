import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Feature/Insights/cubit/insights_cubit.dart';
import 'package:copaw/Feature/Insights/cubit/insights_state.dart';
import 'package:copaw/Feature/widgets/insights/tasks_status_chart.dart';
import 'package:copaw/Feature/widgets/insights/stat_card.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';

class InsightsScreen extends StatelessWidget {
  final UserModel user;

  const InsightsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final appBar = MyCustomAppBar(head: 'Insights', img: null);

    return BlocProvider(
      create: (_) => InsightsCubit()..loadInsightsData(user),
      child: BlocBuilder<InsightsCubit, InsightsState>(
        builder: (context, state) {
          final cubit = context.read<InsightsCubit>();

          return Scaffold(
            appBar: appBar,
            body: _buildBody(context, state, cubit),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    InsightsState state,
    InsightsCubit cubit,
  ) {
    if (state is InsightsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InsightsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => cubit.loadInsightsData(user),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is InsightsLoaded) {
      return RefreshIndicator(
        onRefresh: () => cubit.loadInsightsData(user),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeaderStats(state.projects, state.allTasks),
              const SizedBox(height: 20),
              _buildTasksByStatusChart(state.allTasks),
              const SizedBox(height: 20),
              _buildTaskPerformance(state.allTasks),
              const SizedBox(height: 20),
              _buildPerformanceMetrics(state.projects, state.allTasks),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return const Center(child: Text('No data available'));
  }

  Widget _buildHeaderStats(List<ProjectModel> projects, List<Task> allTasks) {
    final tasksInProgress = _getTasksInProgress(allTasks);
    final projectsOnTime = _getProjectsBeforeDeadline(projects);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Tasks In Progress',
            value: '$tasksInProgress',
            icon: Icons.task_alt,
            color: AppColors.mainColor,
            subtitle: '${allTasks.length} total',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Projects On Time',
            value: '$projectsOnTime',
            icon: Icons.check_circle_outline,
            color: Colors.green,
            subtitle: '${projects.length} total',
          ),
        ),
      ],
    );
  }

  Widget _buildTasksByStatusChart(List<Task> allTasks) {
    final statusData = _getTasksByStatus(allTasks);
    final total = statusData.values.fold<int>(0, (sum, count) => sum + count);

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

    return TasksStatusChart(statusData: statusData, total: total);
  }

  Widget _buildTaskPerformance(List<Task> allTasks) {
    final tasksBeforeDeadline = _getTasksCompletedBeforeDeadline(allTasks);
    final tasksAfterDeadline = _getTasksCompletedAfterDeadline(allTasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            'Task Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:AppColors.text,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Customcontainer(
                Width: double.infinity,
                Height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      '$tasksBeforeDeadline',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      'Completed On Time',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Customcontainer(
                Width: double.infinity,
                Height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$tasksAfterDeadline',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text(
                      'Completed Late',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(
    List<ProjectModel> projects,
    List<Task> allTasks,
  ) {
    final completionRate = _getTaskCompletionRate(allTasks);
    final avgTasksPerProject = _getAvgTasksPerProject(projects, allTasks);
    final tasksDueSoon = _getTasksDueSoon(allTasks);
    final overdueTasks = _getOverdueTasks(allTasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Customcontainer(
          Width: double.infinity,
          Height: null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _MetricRow(
                  label: 'Task Completion Rate',
                  value: '${completionRate.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: completionRate >= 70
                      ? Colors.green
                      : completionRate >= 50
                      ? Colors.orange
                      : Colors.red,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Total Projects',
                  value: '${projects.length}',
                  icon: Icons.folder,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Total Tasks',
                  value: '${allTasks.length}',
                  icon: Icons.task,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Avg Tasks per Project',
                  value: '${avgTasksPerProject.toStringAsFixed(1)}',
                  icon: Icons.analytics,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Tasks Due Soon (3 days)',
                  value: '$tasksDueSoon',
                  icon: Icons.schedule,
                  color: tasksDueSoon > 0 ? Colors.orange : Colors.green,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Overdue Tasks',
                  value: '$overdueTasks',
                  icon: Icons.warning,
                  color: overdueTasks > 0 ? Colors.red : Colors.green,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  int _getTasksInProgress(List<Task> allTasks) {
    return allTasks.where((task) {
      return task.status.toLowerCase() == 'doing';
    }).length;
  }

  int _getProjectsBeforeDeadline(List<ProjectModel> projects) {
    final now = DateTime.now();
    return projects.where((project) {
      if (project.deadline == null || project.tasks.isEmpty) return false;
      final allTasksDone = project.tasks.every(
        (task) => task.status.toLowerCase() == 'done',
      );
      return allTasksDone && project.deadline!.isAfter(now);
    }).length;
  }

  int _getTasksCompletedBeforeDeadline(List<Task> allTasks) {
    final now = DateTime.now();
    return allTasks.where((task) {
      if (task.status.toLowerCase() != 'done') return false;
      if (task.deadline == null) return false;
      // Task was completed (status is done) and deadline hasn't passed yet
      return task.deadline!.isAfter(now);
    }).length;
  }

  int _getTasksCompletedAfterDeadline(List<Task> allTasks) {
    final now = DateTime.now();
    return allTasks.where((task) {
      if (task.status.toLowerCase() != 'done') return false;
      if (task.deadline == null) return false;
      // Task was completed (status is done) but deadline has passed
      return task.deadline!.isBefore(now);
    }).length;
  }

  double _getTaskCompletionRate(List<Task> allTasks) {
    if (allTasks.isEmpty) return 0.0;
    final completed = allTasks
        .where((task) => task.status.toLowerCase() == 'done')
        .length;
    return (completed / allTasks.length) * 100;
  }

  Map<String, int> _getTasksByStatus(List<Task> allTasks) {
    final Map<String, int> statusCount = {'Done': 0, 'Doing': 0, 'To Do': 0};

    for (var task in allTasks) {
      final status = task.status.toLowerCase();
      if (status == 'done') {
        statusCount['Done'] = statusCount['Done']! + 1;
      } else if (status == 'doing') {
        statusCount['Doing'] = statusCount['Doing']! + 1;
      } else {
        statusCount['To Do'] = statusCount['To Do']! + 1;
      }
    }
    return statusCount;
  }

  double _getAvgTasksPerProject(
    List<ProjectModel> projects,
    List<Task> allTasks,
  ) {
    if (projects.isEmpty) return 0.0;
    return allTasks.length / projects.length;
  }

  int _getTasksDueSoon(List<Task> allTasks) {
    final now = DateTime.now();
    final threeDaysLater = now.add(const Duration(days: 3));

    return allTasks.where((task) {
      if (task.deadline == null) return false;
      if (task.status.toLowerCase() == 'done') return false;
      return task.deadline!.isAfter(now) &&
          task.deadline!.isBefore(threeDaysLater);
    }).length;
  }

  int _getOverdueTasks(List<Task> allTasks) {
    final now = DateTime.now();
    return allTasks.where((task) {
      if (task.deadline == null) return false;
      if (task.status.toLowerCase() == 'done') return false;
      return task.deadline!.isBefore(now);
    }).length;
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.mainColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
