import 'package:copaw/Feature/tasks/screens/create_task_screen.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/Projects/cubit/project_detail_cubit.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;
  final UserModel user;

  const ProjectDetailsScreen({super.key, required this.project , required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectDetailsCubit(project),
      child: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          final project = state.project;
          final todoTasks = project.tasks.where((t) => t.status == 'todo');
          final doingTasks = project.tasks.where((t) => t.status == 'doing');
          final doneTasks = project.tasks.where((t) => t.status == 'done');
          
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              title: Text(
                project.name.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectInfo(context, project),
                    const SizedBox(height: 16),
                    _buildMembersSection(context, project),
                    const SizedBox(height: 16),
                    _buildTasksSection(
                      todoTasks.toList(),
                      doingTasks.toList(),
                      doneTasks.toList(),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: CustomButton(
                width: double.infinity,
                label: "Add Task",
                icon: Icons.add,
                inverted: true,
                onPressed: () async {
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateTaskScreen(project: project , user: user),
                    ),
                  );

                  if (newTask != null && context.mounted) {
                    context.read<ProjectDetailsCubit>().addTask(newTask);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectInfo(BuildContext context, ProjectModel project) {
    return Customcontainer(
      Width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project Description",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(project.description.toString()),
        ],
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, ProjectModel project) {
    return Customcontainer(
      Width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Team Members",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: project.users.map((member) {
              return CircleAvatar(
                backgroundImage: NetworkImage(member.avatarUrl ?? ''),
                radius: 20,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(
    List<Task> todo,
    List<Task> doing,
    List<Task> done,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColumn("To Do", todo),
          const SizedBox(width: 12),
          buildColumn("Doing", doing),
          const SizedBox(width: 12),
          buildColumn("Done", done),
        ],
      ),
    );
  }

  Widget buildColumn(String title, List<Task> taskList) {
    return Container(
      width: 300,
      child: Customcontainer(
        Width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...taskList
                .map((task) => TaskItem(task: task, projectUsers: []))
                .toList(),
          ],
        ),
      ),
    );
  }
}
