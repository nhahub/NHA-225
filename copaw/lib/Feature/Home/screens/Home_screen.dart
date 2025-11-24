import 'package:copaw/Feature/Projects/screens/projects_screen.dart';
import 'package:copaw/Feature/Tasks/screens/tasks_screen.dart';
import 'package:copaw/Feature/calender/screens/calender_screen.dart';
import 'package:copaw/Feature/Insights/screens/insights_screen.dart';
import 'package:copaw/Feature/Widgets/Common/custom_bottom_nav.dart';
import 'package:copaw/Models/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user; // ✅ accept the user object

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProjectsScreen(),
      KanbanScreen(user: widget.user),
      CalendarScreen(user: widget.user),
      InsightsScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
