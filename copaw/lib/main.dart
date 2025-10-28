import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Feature/Ai/screens/ai_assistant_screen.dart';
import 'package:copaw/Feature/Auth/screens/login_screen.dart';
import 'package:copaw/Feature/Home/screens/home_screen.dart';
import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/Projects/screens/create_project_screen.dart';
import 'package:copaw/Feature/calender/screens/calender_screen.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/provider/user_cubit.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance.enableNetwork();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => ProjectViewModel()),
      ],
      child: const Copaw(),
    ),
  );
}

class Copaw extends StatelessWidget {
  const Copaw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.mainColor),
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case AppRoutes.createProject:
            return MaterialPageRoute(builder: (_) => const CreateProjectScreen());
          case AppRoutes.calender:
            return MaterialPageRoute(builder: (_) => const CalendarScreen());
          case AppRoutes.Aichat:
            return MaterialPageRoute(builder: (_) => AiAssistantScreen());
          case AppRoutes.home:
            final user = settings.arguments as UserModel?;
            return MaterialPageRoute(
              builder: (_) => HomeScreen(user: user!),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("404 - Page not found")),
              ),
            );
        }
      },
    );
  }
}

/// --- 🔒 AuthGate ---
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<UserModel?> getUserData(String uid) async {
    try {
      return await AuthService.getUserById(uid);
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return LoginScreen();
        }

        return FutureBuilder<UserModel?>(
          future: getUserData(snapshot.data!.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const Scaffold(
                body: Center(child: Text("Failed to load user data")),
              );
            }

            final currentUser = userSnapshot.data!;
            return HomeScreen(user: currentUser);
          },
        );
      },
    );
  }
}
