import 'package:copaw/Feature/Projects/screens/create_project_screen.dart';
import 'package:copaw/Feature/Projects/screens/projects_screen.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'feature/widgets/common/custom_bottom_nav.dart';
import 'Feature/Ai/screens/ai_assistant_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.mainColor),
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.createProject: (context) => const CreateProjectScreen(),
      },
      initialRoute: AppRoutes.home,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProjectsScreen(),
    const KanbanScreen(),
     AiAssistantScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Example Screens
class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Kanban Screen',
        style: TextStyle(fontSize: 22, color: AppColors.textColor),
      ),
    );
  }
}
