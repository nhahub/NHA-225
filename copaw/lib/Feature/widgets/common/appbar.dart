import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
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
      return await AuthService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight, left: 8, right: 8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Stack(
          children: [
            // ✅ Center Title
            Center(
              child: Text(
                head,
                style: const TextStyle(
                  color: Color(0xFF171B1E),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ✅ Right side (notification + avatar)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF3772BB),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8), // spacing
                  InkWell(
                    onTap: () async {
                      // ✅ Get user data from Firebase
                      final user = await _fetchCurrentUser();

                      if (user != null) {
                        // ✅ Navigate and pass user data
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profile,
                          arguments: user,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User data not found.'),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: img != null && img!.isNotEmpty
                          ? NetworkImage(img!)
                          : const AssetImage('assets/NULLP.webp')
                              as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Image not found, using fallback.');
                      },
                    ),
                  ),
                ],
              ),
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
    return Size.fromHeight(statusBarHeight + kToolbarHeight);
  }
}
