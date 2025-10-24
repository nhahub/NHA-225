import 'package:copaw/Feature/tasks/screens/create_task_screen.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';

class KanbanScreen extends StatelessWidget {
  final UserModel user; // 🔹 User passed to this screen

  KanbanScreen({super.key, required this.user});

  final MyCustomAppBar appBar1 = MyCustomAppBar(head: 'My Tasks', img: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1,
    
      body: FutureBuilder<List<Task>>(
        future: TaskService.getTasksByUserId(user.id), // ✅ Fetch tasks for this user
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildColumn("To Do", todoTasks),
                  const SizedBox(width: 12),
                  buildColumn("Doing", doingTasks),
                  const SizedBox(width: 12),
                  buildColumn("Done", doneTasks),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildColumn(String title, List<Task> taskList) {
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
            ...taskList
                .map(
                  (task) => TaskItem(
                    task: task,
                    projectUsers: [], // or add collaborators later
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Future<UserModel?> fetchCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }
}
