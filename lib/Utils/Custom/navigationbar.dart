import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/screens/menu.dart';
import 'package:savvyions/screens/profile.dart';
import '../../screens/mainLandingPage.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _selectedIndex = 1;

  static final List<Widget> _pages = [
    const Menu(),
    const MainLandingPage(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.newBg,
      body: _pages[_selectedIndex],
      // CRITICAL FIX: Wrap bottomNavigationBar in SafeArea
      bottomNavigationBar: SafeArea(
        bottom: true, // This ensures it stays above system navigation
        child: Container(
          height: 7.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.navigationBarColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.menu,
                size: 27,
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _buildNavItem(
                icon: Icons.home_outlined,
                size: 27,
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                size: 27,
                isSelected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    double size = 28,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
         color: isSelected ? AppColors.iconColor.withOpacity(0.2) :Colors.transparent,
         borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: size,
          color: isSelected ? AppColors.iconColor :AppColors.iconDisableColor,
        ),
      ),
    );
  }
}