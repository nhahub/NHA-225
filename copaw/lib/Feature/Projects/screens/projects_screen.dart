import 'package:copaw/Feature/Projects/cubit/project_states.dart';
import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/Projects/screens/project_details_screen.dart';
import 'package:copaw/Feature/widgets/project/project_card.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/utils/app_assets.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final ProjectViewModel projectViewModel = ProjectViewModel();

  @override
  void initState() {
    projectViewModel.getUserProjects(context);
    super.initState();
  }

  Future<UserModel?> fetchCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

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
          'CoPaw',
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
            onPressed: () {},
          ),
          SizedBox(width: width * 0.01),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: width * 0.03),
              width: width * 0.1,
              height: width * 0.1,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AppAssets.placeholder),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {},
          ),
        ],
        backgroundColor: AppColors.transparentColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.001),
          child: Container(color: AppColors.grayColor, height: height * 0.001),
        ),
      ),

      /// ✅ Fetch user before building the project list
      body: FutureBuilder<UserModel?>(
        future: fetchCurrentUser(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text("Unable to load user data."));
          }

          final userModel = userSnapshot.data!;

          return BlocBuilder<ProjectViewModel, ProjectStates>(
            bloc: projectViewModel,
            builder: (context, state) {
              if (state is ProjectLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProjectLoadedState) {
                if (state.projects.isEmpty) {
                  return const Center(
                    child: Text(
                      "No projects found. Create a new project to get started!",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
                    final project = state.projects[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailsScreen(
                              project: project,
                              user: userModel, // ✅ Pass proper UserModel
                            ),
                          ),
                        );
                      },
                      child: ProjectCard(
                        title: project.name.toString(),
                        totalTasks: project.tasks.length,
                        completedTasks: project.tasks
                            .where((t) => t.status == 'done')
                            .length,
                        deadline: project.deadline!.toUtc(),
                        members: [project.users.toString()],
                      ),
                    );
                  },
                );
              } else if (state is ProjectErrorState) {
                return Center(child: Text(state.error));
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
