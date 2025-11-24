import 'package:flutter/material.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/widgets/AI/ProjectList.dart';
import 'package:copaw/Feature/widgets/AI/SelectTasks.dart';
import 'package:copaw/Feature/widgets/AI/customchat.dart';
class AiAssistantScreen extends StatelessWidget {
  AiAssistantScreen({super.key});

  final MyCustomAppBar appBar1 = MyCustomAppBar(
    head: 'AI Assistant',
    img: null,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1,
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
              const Customchat()
            ],
          ),
        ),
      ),
    );
  }
}
