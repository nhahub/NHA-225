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
          gradient: const LinearGradient(
            colors: [AppColors.secondery, AppColors.mainColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.whiteColor,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            currentIndex: currentIndex,
            onTap: onTap,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: _CenteredIcon(Icons.folder_open_outlined),
                activeIcon: _CenteredIcon(Icons.folder),
                label: 'Projects',
              ),
              BottomNavigationBarItem(
                icon: _CenteredIcon(Icons.view_kanban_outlined),
                activeIcon: _CenteredIcon(Icons.view_kanban),
                label: 'Kanban',
              ),
              BottomNavigationBarItem(
                icon: _CenteredIcon(Icons.calendar_month_outlined),
                activeIcon: _CenteredIcon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: _CenteredIcon(Icons.smart_toy_outlined),
                activeIcon: _CenteredIcon(Icons.smart_toy),
                label: 'AI',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenteredIcon extends StatelessWidget {
  final IconData icon;

  const _CenteredIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Align(alignment: Alignment.center, child: Icon(icon)),
    );
  }
}
