import 'package:copaw/Feature/Projects/screens/project_details_screen.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/widgets/project/project_card.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/utils/app_assets.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/Projects/cubit/project_states.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  Future<UserModel?> fetchCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null && firebaseUser.uid.isNotEmpty) {
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser().then((user) {
      if (user != null && user.id != null) {
        context.read<ProjectViewModel>().listenToProjects(user.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder<UserModel?>(
      future: fetchCurrentUser(),
      builder: (context, userSnapshot) {
        final avatarUrl = userSnapshot.data?.avatarUrl;

        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createProject);
            },
            backgroundColor: AppColors.secondery,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 30, color: AppColors.whiteColor),
          ),
          appBar: MyCustomAppBar(head: "CoPaw", img: avatarUrl),

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return InkWell(
                  onTap: () async {
                    final user = await fetchCurrentUser();
                    if (user != null) {
                      // Navigate to project details
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsScreen(
                            project: project,
                            user: user,
                          ),
                        ),
                      );
                      // Refresh projects when returning from detail screen
                      if (context.mounted) {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser != null) {
                          context.read<ProjectViewModel>().listenToProjects(
                            currentUser.uid,
                          );
                        }
                      }
                    }
                  },
                );
              } else if (state is ProjectSuccessState) {
                // ✅ Refresh projects after success
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  context.read<ProjectViewModel>().listenToProjects(user.uid);
                }
                return const Center(child: CircularProgressIndicator());
              }

              // Default fallback - show something instead of looping spinner
              return const Center(child: Text("Loading projects..."));
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectViewModel>().deleteProject(projectId);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
