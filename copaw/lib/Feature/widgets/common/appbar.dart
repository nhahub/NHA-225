import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String head;
  final String? img;

  const MyCustomAppBar({Key? key, required this.head, required this.img})
    : super(key: key);

  Future<UserModel?> _fetchCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mainColor, Color.fromARGB(255, 59, 145, 243)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
          
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
            spreadRadius: -18,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: statusBarHeight + 10,
          bottom: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    head,
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stay on top of your progress',
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(0.75),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                
                GestureDetector(
                  onTap: () async {
                    final user = await _fetchCurrentUser();
                    if (user != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(
                        context,
                        AppRoutes.profile,
                        arguments: user,
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User data not found.')),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.whiteColor.withOpacity(0.15),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: img != null && img!.isNotEmpty
                          ? NetworkImage(img!)
                          : const AssetImage('assets/NULLP.webp')
                                as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Image not found, using fallback.');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    final double statusBarHeight =
        WidgetsBinding.instance.window.padding.top /
        WidgetsBinding.instance.window.devicePixelRatio;
    return Size.fromHeight(statusBarHeight + kToolbarHeight + 18);
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor.withOpacity(0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: AppColors.whiteColor, size: 22),
        ),
      ),
    );
  }
}
