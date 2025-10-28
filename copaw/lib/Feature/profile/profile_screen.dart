import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart'; // ✅ add this
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  /// 🔹 Load current user
  Future<UserModel?> _loadCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  /// 🔹 Fetch counts for projects and tasks
  Future<Map<String, int>> _getCounts(String userId) async {
    final projects = await ProjectService.getUserProjects(userId);
    final tasks = await TaskService.getUserTasks(userId);
    return {
      'projects': projects.length,
      'tasks': tasks.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: user != null ? Future.value(user) : _loadCurrentUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("User not found")),
          );
        }

        final displayedUser = userSnapshot.data!;
        final currentUid = FirebaseAuth.instance.currentUser?.uid;
        final isCurrentUser = displayedUser.id == currentUid;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              isCurrentUser ? 'My Profile' : '${displayedUser.name}\'s Profile',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: FutureBuilder<Map<String, int>>(
            future: _getCounts(displayedUser.id),
            builder: (context, countSnapshot) {
              if (countSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final counts = countSnapshot.data ?? {'projects': 0, 'tasks': 0};

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // 🔹 Avatar section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.blue[100],
                        ),
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage:
                                displayedUser.avatarUrl != null &&
                                        displayedUser.avatarUrl!.isNotEmpty
                                    ? NetworkImage(displayedUser.avatarUrl!)
                                    : const AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🔹 User name + email
                    Text(
                      displayedUser.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayedUser.email,
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 24),

                    // 🔹 Additional info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          _buildInfoTile(Icons.phone, 'Phone',
                              displayedUser.phone ?? 'N/A'),
                          const Divider(),
                          _buildInfoTile(Icons.task_alt, 'Tasks',
                              '${counts['tasks']} assigned'),
                          const Divider(),
                          _buildInfoTile(Icons.work_outline, 'Projects',
                              '${counts['projects']} joined'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Contact button
                    if (!isCurrentUser)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Example: Replace with chat page later
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Start chat with ${displayedUser.name}')),
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text('Contact User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 🔹 Info list tile
  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
