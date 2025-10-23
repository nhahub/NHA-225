import 'package:flutter/material.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/AI/CustomMultipleSelectChoices.dart';

class SelectTasks extends StatefulWidget {
  const SelectTasks({super.key});

  @override
  State<SelectTasks> createState() => _SelectTasksState();
}

class _SelectTasksState extends State<SelectTasks> {
  
  List<String> selectedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Customcontainer(
      Width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose One Task Or More so I can Assist YOU!",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "PROJECT NAME",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColors.grayColor,
                ),
              ),
            ),

           // will be edited in firebase
            CustomMultipleSelectChoices(
              options: const ["Task 1", "Task 2", "Task 3"],
              initiallySelected: const [],
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedTasks = selectedList;
                });
                
                print("Selected Tasks: $selectedTasks");
              },
            ),
          ],
        ),
      ),
    );
  }
}
