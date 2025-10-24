import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Feature/Ai/screens/ai_assistant_screen.dart';
import 'package:copaw/Feature/Auth/screens/login_screen.dart';
import 'package:copaw/Feature/Home/screens/Home_screen.dart';
import 'package:copaw/Feature/Projects/screens/create_project_screen.dart';
import 'package:copaw/Feature/calender/screens/calender_screen.dart';
import 'package:copaw/Feature/tasks/screens/tasks_screen.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance.enableNetwork();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()),
      ],
      child: const Copaw(),
    ),
  );
}

class Copaw extends StatefulWidget {
  const Copaw({super.key});

  @override
  State<Copaw> createState() => _CopawState();
}

class _CopawState extends State<Copaw> {
  UserModel? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userModel = await AuthService.getUserById(firebaseUser.uid);
      setState(() {
        currentUser = userModel;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.mainColor),
      routes: {
        AppRoutes.home: (context) =>  HomePage(user:currentUser!,),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.createProject: (context) => const CreateProjectScreen(),
        AppRoutes.calender: (context) => CalendarScreen(),
        AppRoutes.Aichat: (context) => AiAssistantScreen(),
        AppRoutes.Taskscreen: (context) => KanbanScreen(user: currentUser!),
      },
      initialRoute:
          currentUser == null ? AppRoutes.login : AppRoutes.home,
    );
  }
}
