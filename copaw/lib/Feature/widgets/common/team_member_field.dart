import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// A reusable field that displays a row of team members (avatars)
/// and allows adding new members by typing their email.
class TeamMembersField extends StatelessWidget {
  final List<String> members; // list of member images or avatars
  final Function(String email) onAdd; // callback with entered email

  const TeamMembersField({
    super.key,
    required this.members,
    required this.onAdd,
  });

  /// Opens a dialog to type the email of a new member
  Future<void> _showAddMemberDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Team Member"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Enter member's email",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // close dialog
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                onAdd(email);
                Navigator.pop(context); // close after adding
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

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
              // Display all member avatars
              ...members.map(
                (member) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(member),
                    radius: 20,
                  ),
                ),
              ),

              // Add member button
              GestureDetector(
                onTap: () => _showAddMemberDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
