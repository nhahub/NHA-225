import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/Projects/cubit/project_states.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';
import 'package:copaw/Feature/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/utils/app_colors.dart';

class AddMemberScreen extends StatefulWidget {
  final String projectId;
  const AddMemberScreen({super.key, required this.projectId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _emailController = TextEditingController();
  ProjectModel? _project;
  bool _loadingMembers = true;

  @override
  void initState() {
    super.initState();
    _loadProjectMembers();
  }

  Future<void> _loadProjectMembers() async {
    final project = await ProjectService.getProjectById(widget.projectId);
    setState(() {
      _project = project;
      _loadingMembers = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectViewModel, ProjectStates>(
      listener: (context, state) async {
        if (state is AddMemberSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          await _loadProjectMembers(); // 🔁 Refresh members list
        } else if (state is AddMemberErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProjectViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Project Members",style: TextStyle(color: AppColors.whiteColor),),
            backgroundColor: AppColors.mainColor,
          ),
          body: _loadingMembers
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Project Members:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// --- MEMBERS LIST ---
                        if (_project?.users != null && _project!.users.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _project!.users.length,
                            itemBuilder: (context, index) {
                              final user = _project!.users[index];
                              final bool isLeader =
                                  _project!.leaderId == user.id;

                              return Customcontainer(
                                Width: double.infinity,
                                Height: 70,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: user.avatarUrl != null &&
                                            user.avatarUrl!.isNotEmpty
                                        ? NetworkImage(user.avatarUrl!)
                                        : const AssetImage(
                                            'assets/images/default_avatar.png',
                                          ) as ImageProvider,
                                  ),
                                  title: Row(
                                    children: [
                                      Text(user.name),
                                      const SizedBox(width: 6),
                                      if (isLeader)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: AppColors.orangeDark),
                                          ),
                                          child: const Text(
                                            "Leader",
                                            style: TextStyle(
                                              color: AppColors.orangeDark,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  subtitle: Text(user.email),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProfileScreen(user: user),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        else
                          const Text(
                            "No members yet.",
                            style: TextStyle(color: Colors.grey),
                          ),

                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 12),

                        /// --- ADD NEW MEMBER SECTION ---
                        const Text(
                          "Add new member by email:",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Customcontainer(
                          Width: double.infinity,
                          Height: 60,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "User Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        const SizedBox(height: 20),
                        state is AddMemberLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                label: "Add Member",
                                icon: Icons.person_add_alt_1,
                                inverted: true,
                                onPressed: () {
                                  final email = _emailController.text.trim();
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please enter a valid email."),
                                        backgroundColor: AppColors.orangeDark,
                                      ),
                                    );
                                    return;
                                  }
                                  cubit.addMemberToProject(
                                    widget.projectId,
                                    email,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
