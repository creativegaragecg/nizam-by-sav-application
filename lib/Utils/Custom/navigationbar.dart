import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/providers/auth_provider.dart';
import 'package:savvyions/screens/menu.dart';
import 'package:savvyions/screens/profile.dart';
import '../../Data/token.dart';
import '../../Services/Notification Services.dart';
import '../../Services/Sos Service.dart';
import '../../screens/Web Sos Screen.dart';
import '../../screens/mainLandingPage.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _selectedIndex = 1;
  StreamSubscription? _sosSubscription; // ← add this


  static final List<Widget> _pages = [
    const Menu(),
    const MainLandingPage(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initSos(); // ← call after first frame so context is ready
      // Check if app was opened by tapping a terminated-state notification
      await NotificationService().checkInitialMessage();
    });
  }




  void _initSos() async {
    debugPrint('🔍 _initSos called'); // ← ADD

    // ── Wait for token to be ready ──
    await UserToken().loadUserToken();
    final token = UserToken.token ?? '';
    debugPrint('🔍 _initSos token: $token'); // ← ADD

    if (token.isEmpty) {
      debugPrint('🔍 _initSos: token empty, returning'); // ← ADD

      return;
    }

      // ── Send FCM token to backend ──
      final fcmToken = await NotificationService().getToken();
      if (fcmToken != null) {

        await _saveFcmToken(fcmToken);
      }
      // Refresh if it rotates
      NotificationService().onTokenRefresh.listen(_saveFcmToken);

      final sosService = SosService();

      // ── Cancel any previous subscription first ──
      await _sosSubscription?.cancel();

      // ── Listen BEFORE starting polling so we never miss a fire ──
// ── Listen BEFORE starting polling ──
      _sosSubscription = sosService.listenToSos((sosData) {
        if (!mounted) return;
        if (ModalRoute.of(context)?.settings.name == '/sos') return;
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: '/sos'),
            builder: (_) => WebSosScreen(sosData: sosData),
            fullscreenDialog: true,
          ),
        );
      });

// ── Start polling AFTER listener ──
      sosService.startPolling();


  }

  @override
  void dispose() {
    _sosSubscription?.cancel();
    //SosService().stopPolling();
    super.dispose();
  }


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

  Future<void> _saveFcmToken(String fcmToken) async {
    var body=
    {
      "token": fcmToken,
      "device_type": "android"
    };

    await Provider.of<AuthViewModel>(context, listen: false).saveFCMToken(body, context);

  }
}