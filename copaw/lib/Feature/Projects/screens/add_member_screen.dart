import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/Projects/cubit/project_states.dart';
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
          await _loadProjectMembers(); // refresh members list
        } else if (state is AddMemberErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProjectViewModel>();

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          extendBody: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 90,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), AppColors.mainColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
            ),
            title: Row(
              children: [
                _RoundedIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _project?.name ?? 'Project Members',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _project?.description ?? 'Manage your team',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: const [SizedBox(width: 20)],
          ),
          body: _loadingMembers
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMembersSection(context, _project!),
                      const SizedBox(height: 18),

                      // Add member input block
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 12),
                              spreadRadius: -10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Add new member by email:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                            const SizedBox(height: 8),
                            Text(
                              'Enter the email of the teammate you want to invite to this project.',
                              style: TextStyle(
                                color: AppColors.textColor.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (state is AddMemberLoadingState)
                              const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: CustomButton(
              width: double.infinity,
              label: "Add Member",
              icon: Icons.person_add_alt_1,
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid email."),
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
          ),
        );
      },
    );
  }

  Widget _buildMembersSection(BuildContext context, ProjectModel project) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  "Members",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "${project.users.length} Teammate",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

            
            ],
          ),

          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 360;

              return Wrap(
                spacing: 12,
                runSpacing: 16,
                children: project.users.map((member) {
                  final avatar = member.avatarUrl;

                  return SizedBox(
                    width: isSmall ? 60 : 70,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: isSmall ? 24 : 26,
                          backgroundColor: AppColors.mainColor.withOpacity(0.1),
                          child: CircleAvatar(
                            radius: isSmall ? 21 : 23,
                            backgroundImage: (avatar != null && avatar.isNotEmpty)
                                ? NetworkImage(avatar)
                                : const AssetImage('assets/NULLP.webp') as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          member.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmall ? 11 : 12,
                            color: AppColors.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 12),

          // members list
          const SizedBox(height: 8),
          if (project.users.isEmpty)
            Text(
              "No members yet.",
              style: TextStyle(color: AppColors.textColor.withOpacity(0.6)),
            )
          else
            Column(
              children: project.users.map((user) {
                final bool isLeader = project.leaderId == user.id;
                return Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withOpacity(0.03)),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? NetworkImage(user.avatarUrl!)
                          : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                    title: Row(
                      children: [
                        Text(user.name),
                        const SizedBox(width: 6),
                        if (isLeader)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.orangeDark),
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
                          builder: (_) => ProfileScreen(user: user),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundedIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}