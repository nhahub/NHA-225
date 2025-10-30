import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final int totalTasks;
  final int completedTasks;
  final DateTime deadline;
  final List<String> members;
  final VoidCallback? onDelete; // ✅ new optional callback

  const ProjectCard({
    super.key,
    required this.title,
    required this.totalTasks,
    required this.completedTasks,
    required this.deadline,
    required this.members,
    this.onDelete, // ✅ optional delete handler
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
            /// ✅ Title row with delete icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor,
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Project"),
                          content: const Text(
                              "Are you sure you want to delete this project?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) widget.onDelete!();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),

            /// Progress Bar
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

            /// Members
            Row(
              children: widget.members.asMap().entries.map((entry) {
                int index = entry.key;
                String member = entry.value;

                return Transform.translate(
                  offset: Offset(-index * 12, 0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: AssetImage(member),
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
