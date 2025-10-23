import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/utils/app_colors.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final List<UserModel> projectUsers; // أرسلها من الشاشة

  const TaskItem({super.key, required this.task, required this.projectUsers});

  Color getStatusColor() {
    final now = DateTime.now();
    if (task.deadline == null) return Colors.grey.shade400;

    final diffDays = task.deadline!.difference(now).inDays;

    if (task.status.toLowerCase() == 'done') return Colors.green;
    if (task.status.toLowerCase() == 'doing') {
      if (diffDays <= 1) return Colors.blueAccent.shade700;
      if (diffDays <= 3) return Colors.blueAccent.shade400;
      return Colors.blue.shade200;
    }
    if (task.status.toLowerCase() == 'todo') {
      if (diffDays < 0) return Colors.redAccent;
      if (diffDays <= 1) return Colors.deepOrange;
      if (diffDays <= 3) return Colors.orangeAccent;
      if (diffDays <= 7) return Colors.amber;
      return Colors.grey.shade400;
    }
    return AppColors.mainColor;
  }

  @override
  Widget build(BuildContext context) {
    final sideColor = getStatusColor();

    // 🧑‍💻 المستخدمين المعيّنين في المهمة
    final assignedUsers = projectUsers
        .where((u) => task.assignedTo.contains(u.id))
        .toList();

    return Customcontainer(
      Width: double.infinity,
      Height: 160,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      sideColor: sideColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            task.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54),
          ),
          const Spacer(),


          Row(
            children: assignedUsers.map((user) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                  backgroundColor: Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          // 📅 التاريخ + الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_sharp,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    task.deadline != null
                        ? "${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}"
                        : "No deadline",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Text(
                task.status.toUpperCase(),
                style: TextStyle(
                  color: sideColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
