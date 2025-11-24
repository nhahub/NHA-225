import 'package:copaw/Feature/tasks/bloc/create_task_cubit.dart';
import 'package:copaw/Feature/tasks/bloc/create_task_state.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KanbanScreen extends StatelessWidget {
  final UserModel user;
  const KanbanScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateTaskCubit()..loadUserTasks(user),
      child: BlocBuilder<CreateTaskCubit, CreateTaskState>(
        builder: (context, state) {
          final cubit = context.read<CreateTaskCubit>();
          final appBar1 = MyCustomAppBar(head: 'My Tasks', img: user.avatarUrl);

          return Scaffold(
            appBar: appBar1,

            body: Builder(
              builder: (context) {
                if (state is CreateTaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CreateTaskError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else if (state is CreateTaskSuccessList) {
                  final tasks = state.tasks;

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text("No tasks found for this user"),
                    );
                  }

                  final todoTasks = tasks
                      .where((t) => t.status == "todo")
                      .toList();
                  final doingTasks = tasks
                      .where((t) => t.status == "doing")
                      .toList();
                  final doneTasks = tasks
                      .where((t) => t.status == "done")
                      .toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildColumn("To Do", todoTasks),
                          const SizedBox(width: 12),
                          _buildColumn("Doing", doingTasks),
                          const SizedBox(width: 12),
                          _buildColumn("Done", doneTasks),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildColumn(String title, List<Task> taskList) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 10),
      child: Customcontainer(
        Width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (taskList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("No tasks", style: TextStyle(color: Colors.grey)),
              ),
            ...taskList
                .map((task) => TaskItem(task: task, projectUsers: []))
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
