import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.bgCard,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
      elevation: 8,
      indicatorColor: AppColors.accentGlow,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(CupertinoIcons.house),
          selectedIcon: Icon(
            CupertinoIcons.house_fill,
            color: AppColors.accentPrimary,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.list_bullet),
          selectedIcon: Icon(
            CupertinoIcons.list_bullet,
            color: AppColors.accentPrimary,
          ),
          label: 'Queue',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.settings),
          selectedIcon: Icon(
            CupertinoIcons.settings_solid,
            color: AppColors.accentPrimary,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
