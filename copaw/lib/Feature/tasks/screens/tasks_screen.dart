import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'package:flutter/material.dart';

class KanbanScreen extends StatelessWidget {
  final UserModel user; // 🔹 Current logged-in user

  KanbanScreen({super.key, required this.user});

  final MyCustomAppBar appBar1 = MyCustomAppBar(head: 'My Tasks', img: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1,
      body: FutureBuilder<List<Task>>(
  future: TaskService.getTasksForUserByIds(user), // ✅ Fetch tasks by user's taskIds
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text("No tasks found for this user"));
    }

    final tasks = snapshot.data!;
    final todoTasks = tasks.where((t) => t.status == "todo").toList();
    final doingTasks = tasks.where((t) => t.status == "doing").toList();
    final doneTasks = tasks.where((t) => t.status == "done").toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
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
    );
  },
),

    );
  }

  Widget _buildColumn(String title, List<Task> taskList) {
    return Container(
      width: 320,
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
                child: Text(
                  "No tasks",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ...taskList
                .map(
                  (task) => TaskItem(
                    task: task,
                    projectUsers: [], // Add collaborators if needed
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
