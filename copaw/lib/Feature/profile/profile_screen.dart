import 'package:copaw/Feature/Auth/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'package:copaw/Feature/Auth/screens/login_screen.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:copaw/Feature/Auth/cubit/user_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

  Future<UserModel?> _loadCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  Future<Map<String, int>> _getCounts(String userId) async {
    final projects = await ProjectService.getUserProjects(userId);
    final tasks = await TaskService.getUserTasks(userId);
    return {'projects': projects.length, 'tasks': tasks.length};
  }

  Future<void> _pickAndUploadImage(UserModel currentUser) async {
    print("DEBUG: _pickAndUploadImage called");

    // 1. Request Permissions
    PermissionStatus status;
    if (Platform.isAndroid) {
      // For Android 13+ (SDK 33+), use READ_MEDIA_IMAGES if available,
      // but permission_handler handles this logic mostly.
      // For older Android, READ_EXTERNAL_STORAGE.
      // We'll try requesting storage first.
      final storageStatus = await Permission.storage.request();
      // If that's denied or restricted, try photos (Android 13+)
      if (!storageStatus.isGranted) {
        status = await Permission.photos.request();
      } else {
        status = storageStatus;
      }
    } else {
      // iOS
      status = await Permission.photos.request();
    }

    print("DEBUG: Permission status: $status");

    if (status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Permission permanently denied. Please enable in settings.",
            ),
          ),
        );
        openAppSettings();
      }
      return;
    }

    // Note: On some Android versions, if the user has already granted "limited" access
    // or if the picker is a system picker (Photo Picker), we might not strictly NEED
    // this permission check to pass as 'granted' for the picker to work,
    // but it's good practice to check.
    // However, the image_picker plugin often handles the system picker which requires NO permissions.
    // So we will proceed even if status is not explicitly 'granted', but log it.

    final picker = ImagePicker();
    XFile? pickedFile;
    try {
      print("DEBUG: Opening ImagePicker...");
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false, // Optimization
      );
      print("DEBUG: ImagePicker returned: ${pickedFile?.path}");
    } catch (e) {
      print("DEBUG: Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
      }
      return;
    }

    if (pickedFile == null) {
      print("DEBUG: User canceled picker");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child(
        'user_avatars/${currentUser.id}',
      );

      print("DEBUG: Uploading to ${storageRef.fullPath}");
      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();
      print("DEBUG: Upload success. URL: $downloadUrl");

      // Update Firestore
      final updatedUser = currentUser.copyWith(avatarUrl: downloadUrl);
      await AuthService.addUserToFirestore(updatedUser);

      // Update Cubit
      if (mounted) {
        context.read<UserCubit>().setUser(updatedUser);
      }

      setState(() {}); // Refresh UI
    } catch (e) {
      print("DEBUG: Upload failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Image upload failed: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// 🔹 Logout logic (Firebase only)
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: widget.user != null
          ? Future.value(widget.user)
          : _loadCurrentUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!userSnapshot.hasData) {
          return const Scaffold(body: Center(child: Text("User not found")));
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
                    // Avatar section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.blue[100],
                        ),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: isCurrentUser
                                  ? () {
                                      print("DEBUG: Avatar tapped");
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Checking permissions...",
                                          ),
                                        ),
                                      );
                                      _pickAndUploadImage(displayedUser);
                                    }
                                  : () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "You can only edit your own profile",
                                          ),
                                        ),
                                      );
                                    },
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      displayedUser.avatarUrl != null &&
                                          displayedUser.avatarUrl!.isNotEmpty
                                      ? NetworkImage(displayedUser.avatarUrl!)
                                      : const AssetImage(
                                              'assets/images/default_avatar.png',
                                            )
                                            as ImageProvider,
                                ),
                              ),
                            ),
                            if (_isUploading)
                              const Positioned.fill(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            if (isCurrentUser)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Name & Email
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

                    // Info tiles
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          _buildInfoTile(
                            Icons.phone,
                            'Phone',
                            displayedUser.phone ?? 'N/A',
                          ),
                          const Divider(),
                          _buildInfoTile(
                            Icons.task_alt,
                            'Tasks',
                            '${counts['tasks']} assigned',
                          ),
                          const Divider(),
                          _buildInfoTile(
                            Icons.work_outline,
                            'Projects',
                            '${counts['projects']} joined',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          if (!isCurrentUser)
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Start chat with ${displayedUser.name}',
                                    ),
                                  ),
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

                          // Logout button for current user
                          if (isCurrentUser)
                            ElevatedButton.icon(
                              onPressed: () => _logout(context),
                              icon: const Icon(
                                Icons.logout,
                                color: AppColors.whiteColor,
                              ),
                              label: const Text(
                                'Logout',
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orangeDark,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                        ],
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
