import 'package:copaw/Feature/tasks/screens/edittask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/Projects/cubit/project_detail_cubit.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'package:copaw/Feature/tasks/screens/create_task_screen.dart';
import 'package:copaw/Feature/Projects/screens/add_member_screen.dart';
import 'package:copaw/utils/app_colors.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;
  final UserModel user;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectDetailsCubit(project),
      child: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          final project = state.project;

          final todoTasks =
              project.tasks.where((t) => t.status == 'todo').toList();
          final doingTasks =
              project.tasks.where((t) => t.status == 'doing').toList();
          final doneTasks =
              project.tasks.where((t) => t.status == 'done').toList();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              title: Text(
                project.name ?? 'Project',
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
                    _buildTasksSection(context, todoTasks, doingTasks,
                        doneTasks, project.users),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: CustomButton(
                width: double.infinity,
                label: "Add Task",
                icon: Icons.add,
                inverted: true,
                onPressed: () async {
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CreateTaskScreen(project: project, user: user),
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
          Text("Project Description",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(project.description ?? 'No description provided.'),
        ],
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, ProjectModel project) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMemberScreen(projectId: project.id!),
          ),
        );
      },
      child: Customcontainer(
        Width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Team Members",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: project.users
                  .map((member) => CircleAvatar(
                        backgroundImage:
                            NetworkImage(member.avatarUrl ?? ''),
                        radius: 20,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18, color: Colors.blueAccent),
                SizedBox(width: 4),
                Text("Tap to add more members",
                    style: TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context, List<Task> todo,
      List<Task> doing, List<Task> done, List<UserModel> projectUsers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskColumn(context, "To Do", todo, projectUsers),
          const SizedBox(width: 12),
          _buildTaskColumn(context, "Doing", doing, projectUsers),
          const SizedBox(width: 12),
          _buildTaskColumn(context, "Done", done, projectUsers),
        ],
      ),
    );
  }

  Widget _buildTaskColumn(BuildContext context, String title,
      List<Task> taskList, List<UserModel> projectUsers) {
    final cubit = context.read<ProjectDetailsCubit>();

    return SizedBox(
      width: 300,
      child: Customcontainer(
        Width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...taskList.map((task) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Stack(
                  children: [
                    TaskItem(task: task, projectUsers: projectUsers),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final editedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTaskScreen(
                                  project: cubit.state.project,
                                  user: cubit.state.project.users.first, 
                                  task: task, // pass current task for editing
                                ),
                              ),
                            );

                            if (editedTask != null && context.mounted) {
                              await cubit.editTask(editedTask);
                            }
                          } else if (value == 'delete') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Delete Task?'),
                                content:
                                    const Text('Are you sure you want to delete this task?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await TaskService.deleteTask(task.id, cubit.state.project);
                              await cubit.retrieveTasks();
                            }
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
