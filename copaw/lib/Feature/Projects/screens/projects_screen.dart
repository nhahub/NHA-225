import 'package:copaw/Feature/widgets/project/project_card.dart';
import 'package:copaw/utils/app_assets.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createProject);
        },
        backgroundColor: AppColors.mainColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: AppColors.whiteColor),
      ),
      appBar: AppBar(
        title: const Text(
          'Co-Paw',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_on_outlined,
              color: AppColors.mainColor,
              size: 32,
            ),
            onPressed: () {
              // Handle notification icon press
            },
          ),

          SizedBox(width: width * 0.01),

          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: width * 0.03),
              width: width * 0.1,
              height: width * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage(AppAssets.placeholder),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              // Handle profile picture tap
            },
          ),
        ],
        backgroundColor: AppColors.transparentColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            height * 0.001,
          ), // Height of the divider
          child: Container(
            color: AppColors.grayColor, // Divider color
            height: height * 0.001, // Divider height
          ),
        ),
      ),
      body: ListView(
        children: [
          ProjectCard(
            title: "ForgeFlow AI App Development",
            totalTasks: 20,
            completedTasks: 12,
            deadline: DateTime(2024, 8, 15),
            members: [
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
            ],
          ),
          ProjectCard(
            title: "ForgeFlow AI App Development",
            totalTasks: 20,
            completedTasks: 19,
            deadline: DateTime(2024, 8, 15),
            members: [AppAssets.placeholder, AppAssets.placeholder],
          ),
          ProjectCard(
            title: "ForgeFlow AI App Development",
            totalTasks: 20,
            completedTasks: 11,
            deadline: DateTime(2024, 8, 15),
            members: [
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
            ],
          ),
          ProjectCard(
            title: "ForgeFlow AI App Development",
            totalTasks: 20,
            completedTasks: 15,
            deadline: DateTime(2024, 8, 15),
            members: [
              AppAssets.placeholder,
              AppAssets.placeholder,
              AppAssets.placeholder,
            ],
          ),
        ],
      ),
    );
  }
}
