import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:copaw/Models/project_model.dart'; // adjust import as needed

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as ProjectModel;

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Tasks: ${project.totalTasks}'),
            Text('Completed Tasks: ${project.doneTasks.length}'),
            Text(
              "${project.deadline.toLocal()}".split(' ')[0],
              style: const TextStyle(color: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
