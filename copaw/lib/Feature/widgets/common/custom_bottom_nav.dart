import 'package:flutter/material.dart';
import '/utils/constants.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.mainColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.textColor.withOpacity(0.6),
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_open),
          label: 'Projects',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_kanban),
          label: 'Kanban',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          label: 'AI Assistant',
        ),
      ],
    );
  }
}
