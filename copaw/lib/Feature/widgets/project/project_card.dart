import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final int totalTasks;
  final int completedTasks;
  final DateTime deadline;
  final List<String> members; // List of member image URLs or asset paths

  const ProjectCard({
    super.key,
    required this.title,
    required this.totalTasks,
    required this.completedTasks,
    required this.deadline,
    required this.members,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double progress = widget.totalTasks == 0
        ? 0
        : widget.completedTasks / widget.totalTasks;

    return Card(
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightGrayColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.01,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Project Title
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 10),

            /// Progress Bar with %
            Row(
              children: [
                const Text("Progress: "),
                Expanded(
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(5),
                    value: progress,
                    minHeight: 10,
                    backgroundColor: AppColors.lightGrayColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.mainColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text("${(progress * 100).toStringAsFixed(0)}%"),
              ],
            ),
            const SizedBox(height: 12),

            /// Deadline
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 24,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Text(
                  "${widget.deadline.toLocal()}".split(' ')[0],
                  style: const TextStyle(color: AppColors.textColor),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),

            /// Members avatars
            Row(
              children: widget.members.asMap().entries.map((entry) {
                int index = entry.key;
                String member = entry.value;

                return Transform.translate(
                  offset: Offset(
                    -index * 12,
                    0,
                  ), // move left by 12 pixels per index
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 2,
                      ), // white border
                      image: DecorationImage(
                        image: AssetImage(
                          member,
                        ), // replace with NetworkImage(member)
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
