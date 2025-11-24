import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: AppColors.secondery,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 14),
              spreadRadius: -10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Theme(
            data: Theme.of(context).copyWith(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.whiteColor,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              currentIndex: currentIndex,
              onTap: onTap,
              showUnselectedLabels: false,

              iconSize: 24,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_open_outlined),
                  activeIcon: Icon(Icons.folder),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_kanban_outlined),
                  activeIcon: Icon(Icons.view_kanban),
                  label: 'Kanban',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  activeIcon: Icon(Icons.calendar_month),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights_outlined),
                  activeIcon: Icon(Icons.insights),
                  label: 'Insights',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
