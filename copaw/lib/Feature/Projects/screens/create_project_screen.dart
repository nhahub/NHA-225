import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Feature/widgets/common/date_picker_field.dart';
import 'package:copaw/Feature/widgets/common/team_member_field.dart';
import 'package:copaw/utils/app_assets.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController projectNameController = TextEditingController();
  String selectedDate = "Sep 24, 2025";
  List<String> teamMembers = [
    AppAssets.placeholder,
    AppAssets.placeholder,
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mainColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("New Project",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.001),
          child: Container(color: AppColors.grayColor, height: height * 0.001),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.03),
            CustomTextField(
              label: "Project Title",
              hintText: "Enter project name",
              controller: projectNameController,
            ),
            SizedBox(height: height * 0.03),
            DatePickerField(
              label: "Deadline",
              dateText: selectedDate,
              onTap: () {
                // open date picker
              },
            ),
            SizedBox(height: height * 0.03),
            TeamMembersField(
              members: teamMembers,
              onAdd: () {
                // open add member dialog
              },
            ),
            SizedBox(height: height * 0.03),
            CustomButton(
              label: "Create Project",
              onPressed: () {
                // Handle project creation
              },
            ),
          ],
        ),
      ),
    );
  }
}

