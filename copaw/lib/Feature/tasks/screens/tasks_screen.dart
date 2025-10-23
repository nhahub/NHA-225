import 'package:copaw/Feature/tasks/screens/create_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';

class KanbanScreen extends StatelessWidget {
  KanbanScreen({super.key});

  final MyCustomAppBar appBar1 = MyCustomAppBar(head: 'Tasks', img: null);

  final List<Task> tasks = [
    Task(
      id: "1",
      title: "Design UI for Project List Screen",
      description: "Create modern UI for project cards",
      assignedTo: "user_1",
      status: "todo",
      deadline: DateTime.now(),
      createdAt: DateTime.now(),
      projectId: "p1",
      isCompleted: false,
      createdBy: "leader_1",
    ),
    Task(
      id: "2",
      title: "Implement authentication module",
      description: "Add login and signup features",
      assignedTo: "user_2",
      status: "doing",
      deadline: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      projectId: "p1",
      isCompleted: false,
      createdBy: "leader_1",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final todoTasks = tasks.where((t) => t.status == "todo").toList();
    final doingTasks = tasks.where((t) => t.status == "doing").toList();

    return Scaffold(
      appBar: appBar1,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn("To Do", todoTasks),
              const SizedBox(width: 16),
              buildColumn("Doing", doingTasks),
            ],
          ),
        ),
      ),
      
      // ✅ Add Task Button at Bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.only(right: 30,left: 30),
          child: CustomButton(
            width: double.infinity,
            label: "Add Task",
            icon: Icons.add,
            inverted: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTaskScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildColumn(String title, List<Task> taskList) {
    return Container(
      width: 320, // Wider columns
      margin: const EdgeInsets.only(right: 10),
      child: Customcontainer(
        Width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column Title
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

            // Tasks
            ...taskList.map((task) => TaskItem(task: task)).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
