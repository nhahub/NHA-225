import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Feature/Ai/screens/ai_assistant_screen.dart';
import 'package:copaw/Feature/Auth/screens/login_screen.dart';
import 'package:copaw/Feature/Home/screens/Home_screen.dart';
import 'package:copaw/Feature/Projects/screens/create_project_screen.dart';
import 'package:copaw/Feature/Projects/screens/project_details_screen.dart';
import 'package:copaw/Feature/calender/screens/calender_screen.dart';
import 'package:copaw/provider/user_cubit.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Feature/tasks/screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance.enableNetwork();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => UserCubit())],
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
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.createProject: (context) => const CreateProjectScreen(),
        AppRoutes.calender: (context) => CalendarScreen(),
        AppRoutes.Aichat: (context) => AiAssistantScreen(),
        AppRoutes.Taskscreen: (context) => KanbanScreen(),
      },
      initialRoute: AppRoutes.login,
    );
  }
}
