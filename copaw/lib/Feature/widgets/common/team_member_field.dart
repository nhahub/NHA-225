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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                onAdd(email);
                Navigator.pop(context);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Team Members",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            if (members.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "${members.length} active",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.grayColor.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 12),
                spreadRadius: -10,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: members
                        .map((member) => _AvatarChip(image: member))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _AddMemberButton(onTap: () => _showAddMemberDialog(context)),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarChip extends StatelessWidget {
  final String image;

  const _AvatarChip({required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.mainColor.withOpacity(0.1),
        child: CircleAvatar(radius: 20, backgroundImage: AssetImage(image)),
      ),
    );
  }
}

class _AddMemberButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMemberButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mainColor.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: const [
              Icon(Icons.add, size: 18, color: AppColors.mainColor),
              SizedBox(width: 6),
              Text(
                "Add",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
