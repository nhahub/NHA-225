import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TeamMembersField extends StatelessWidget {
  final List<String> members;
  final VoidCallback onAdd;

  const TeamMembersField({
    super.key,
    required this.members,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Team Members",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grayColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ...members.map(
                (member) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(member), // or NetworkImage
                    radius: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grayColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 18, color: Colors.black54),
                      SizedBox(width: 6),
                      Text(
                        "Add Member",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
