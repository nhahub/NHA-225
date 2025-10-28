import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  /// 🔹 تحميل المستخدم الحالي من Firebase
  Future<UserModel?> _loadCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: user != null ? Future.value(user) : _loadCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("User not found")),
          );
        }

        final displayedUser = snapshot.data!;
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                // avatar section
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
                        backgroundImage: displayedUser.avatarUrl != null &&
                                displayedUser.avatarUrl!.isNotEmpty
                            ? NetworkImage(displayedUser.avatarUrl!)
                            : const AssetImage('assets/images/default_avatar.png')
                                as ImageProvider,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // user name + email
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

                // additional info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildInfoTile(
                          Icons.phone, 'Phone', displayedUser.phone ?? 'N/A'),
                      const Divider(),
                      _buildInfoTile(Icons.task_alt, 'Tasks',
                          '${displayedUser.taskIds.length} assigned'),
                      const Divider(),
                      _buildInfoTile(Icons.work_outline, 'Projects',
                          '${displayedUser.projectId.length} joined'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // if this is not the current user, show contact button
                if (!isCurrentUser)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // مثال فقط: يمكنك إضافة صفحة محادثة هنا
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Start chat with ${displayedUser.name}')),
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
          ),
        );
      },
    );
  }

  /// 🔹 items display
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
