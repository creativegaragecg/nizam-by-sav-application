import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/images.dart';
import 'package:savvyions/Utils/Custom/custom_text.dart';
import 'package:savvyions/screens/onBoardingScreens.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _fadeController.forward();
  }

  void _navigateToOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.seaGreenColor.withOpacity(0.05),
              AppColors.lightYellowColor.withOpacity(0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
          SizedBox(height: 15.h,),
                  // Floating Logo
                 /* AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.greenColor.withOpacity(0.08),
                                blurRadius: 40,
                                spreadRadius: 5,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Image.asset(
                              AppImages.splashScreenLogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),*/

                  SizedBox(height: 6.h),

                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                         Colors.black,
                          Colors.black.withOpacity(0.7),
                        ],
                      ).createShader(bounds);
                    },
                    child: CustomText(
                      text: 'Welcome To',
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        //  letterSpacing: ,
                        height: 1,
                      ),
                      align: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 8.h),
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          width: 55.w,
                          height: 55.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.greenColor.withOpacity(0.08),
                                blurRadius: 40,
                                spreadRadius: 5,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Image.asset(
                              AppImages.welcomeLogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                 /* Container(
                   width: 80.w,
                      height: 30.h,
                   //   color: Colors.blueGrey,
                      child: Image.asset(AppImages.welcomeLogo,fit: BoxFit.contain,)),*/

                 /* // App Name
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          AppColors.greenColor,
                          AppColors.greenColor.withOpacity(0.7),
                        ],
                      ).createShader(bounds);
                    },
                    child: CustomText(
                      text: 'Nizaam',
                      style: TextStyle(
                        fontSize: 40.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      //  letterSpacing: ,
                        height: 1,
                      ),
                      align: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Subtitle
                  CustomText(
                    text: 'by Savviyons',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                    align: TextAlign.center,
                  ),*/

                 /* SizedBox(height: 4.h),

                  // Divider
                  Container(
                    width: 50.w,
                    height: 0.2.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.greenColor.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Tagline
                  CustomText(
                    text: 'Smart Community\nManagement',
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: AppColors.greenColor.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                    align: TextAlign.center,
                  ),*/

                  SizedBox(height: 10.h),

                  // Get Started Button
                  GestureDetector(
                    onTap: _navigateToOnboarding,
                    child: Container(
                      width: double.infinity,
                      height: 6.5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.greenColor.withOpacity(0.9),
                            AppColors.greenColor.withOpacity(0.5),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greenColor.withOpacity(0.15),
                            blurRadius: 25,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Get Started',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Subtle hint
                  CustomText(
                    text: 'Tap to continue',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.greenColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                    align: TextAlign.center,
                  ),

                 /* SizedBox(height: 4.h),

                  // Decorative dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: 1.5.w,
                        height: 1.5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.greenColor,
                        ),
                      );
                    }),
                  ),*/

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}