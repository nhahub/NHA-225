import 'package:flutter/material.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/AI/ProjectList.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/AI/SelectTasks.dart';
import 'package:copaw/Feature/widgets/AI/customchat.dart';
import 'package:copaw/Models/user.dart';

class AiAssistantScreen extends StatelessWidget {
  final UserModel user;

  const AiAssistantScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(head: 'AI Assistant', img: user.avatarUrl),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const Projectlist(),

              const SizedBox(height: 20),

              const SelectTasks(),
              const SizedBox(height: 50),
              const Customchat(),
            ],
          ),
        ),
      ),
    );
  }
}
