import 'package:copaw/Feature/Ai/screens/ai_assistant_screen.dart';
import 'package:copaw/Feature/Projects/screens/projects_screen.dart';
import 'package:copaw/Feature/calender/screens/calender_screen.dart';
import 'package:copaw/Feature/tasks/screens/tasks_screen.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/feature/widgets/common/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages using the passed user
    _pages = [
      const ProjectsScreen(),
      KanbanScreen(user: widget.user),
      CalendarScreen(),
      AiAssistantScreen(),
    ];
  }

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
