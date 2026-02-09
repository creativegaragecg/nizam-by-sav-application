import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/styles.dart';
import 'package:savvyions/Utils/Custom/custom_text.dart';
import 'package:savvyions/swipeUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _iconAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Icon animation controller
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeIn,
      ),
    );

    // Start animations
    _iconAnimationController.forward();
    _fadeAnimationController.forward();
  }

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.receipt_long_rounded,
      title: 'Smart Billing System',
      description: 'Automated Billing for Rent, Utilities and Maintenance',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.greenColor.withOpacity(0.2),
          AppColors.seaGreenColor,
        ],
      ),
    ),
    OnboardingData(
      icon: Icons.payment_rounded,
      title: 'Secure Payment Processing',
      description: 'Integrated Payments via Stripe and Razorpay',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.buttonColor.withOpacity(0.2),
          AppColors.yellowColor.withOpacity(0.3),
        ],
      ),
    ),
    OnboardingData(
      icon: Icons.campaign_rounded,
      title: 'Community Updates',
      description: 'Centralized Notice Board for Communications',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.lightYellowColor.withOpacity(0.5),
          AppColors.bgColor,
        ],
      ),
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Restart animations for new page
    _iconAnimationController.reset();
    _fadeAnimationController.reset();
    _iconAnimationController.forward();
    _fadeAnimationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _getStarted() async {
    // Navigate to your main app screen
    final prefs = await SharedPreferences.getInstance();
 prefs.setBool("welcomePages", true);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  SwipeUpScreen ()),
          (route) => false,
    );
    print('Get Started pressed');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _pages[index],
                    iconScaleAnimation: _iconScaleAnimation,
                    iconRotationAnimation: _iconRotationAnimation,
                    fadeAnimation: _fadeAnimation,
                  );
                },
              ),
            ),

            // Page Indicators
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    height: 2.w,
                    width: _currentPage == index ? 8.w : 2.w,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.greenColor
                          : AppColors.hintText.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            // Skip Button (only show on first two pages)
            if (_currentPage < _pages.length - 1)
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextButton(
                  onPressed: _skipToEnd,
                  child: CustomText(
                    text: 'Skip',
                    style: basicColor(16, AppColors.hintText),
                  ),
                ),
              ),

            // Next/Get Started Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: SizedBox(
                  key: ValueKey<int>(_currentPage),
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: _currentPage == _pages.length - 1
                        ? _getStarted
                        : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: basicColorBold(18, Colors.white),
                        ),
                        if (_currentPage != _pages.length - 1) ...[
                          SizedBox(width: 2.w),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20.sp),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final Animation<double> iconScaleAnimation;
  final Animation<double> iconRotationAnimation;
  final Animation<double> fadeAnimation;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.iconScaleAnimation,
    required this.iconRotationAnimation,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: data.gradient,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Icon Circle with pulse effect
            AnimatedBuilder(
              animation: iconScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: iconScaleAnimation.value,
                  child: Transform.rotate(
                    angle: iconRotationAnimation.value * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsing ring effect
                        Container(
                          width: 55.w,
                          height: 55.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.greenColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.greenColor,
                                AppColors.buttonColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.greenColor.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            data.icon,
                            size: 25.w,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 8.h),

            // Animated Title
            FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: fadeAnimation,
                  curve: Curves.easeOut,
                )),
                child: CustomText(
                  text: data.title,
                  style: basicColorBold(25, AppColors.greenColor),
                  align: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Animated Description
            FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: fadeAnimation,
                  curve: Curves.easeOut,
                )),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomText(
                    text: data.description,
                    style: basicColor(16, AppColors.greenColor),
                    align: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}