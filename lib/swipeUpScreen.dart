import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/images.dart';
import 'package:savvyions/Utils/Constants/styles.dart';
import 'package:savvyions/Utils/Custom/custom_text.dart';
import 'package:savvyions/screens/qrScreen.dart';

class SwipeUpScreen extends StatefulWidget {
  const SwipeUpScreen({super.key});

  @override
  State<SwipeUpScreen> createState() => _SwipeUpScreenState();
}

class _SwipeUpScreenState extends State<SwipeUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _swipeAnimationController;
  late AnimationController _qrPulseController;
  late AnimationController _slideUpController;
  late AnimationController _infoFadeController;
  late Animation<double> _swipeAnimation;
  late Animation<double> _qrPulseAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _infoFadeAnimation;

  bool _isNavigating = false;
  bool _showInfo = false;

  @override
  void initState() {
    super.initState();

    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _swipeAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _swipeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _qrPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _qrPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _qrPulseController,
        curve: Curves.easeInOut,
      ),
    );

    _slideUpController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideUpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(
        parent: _slideUpController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _slideUpController,
        curve: Curves.easeInOut,
      ),
    );

    _infoFadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _infoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _infoFadeController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    _qrPulseController.dispose();
    _slideUpController.dispose();
    _infoFadeController.dispose();
    super.dispose();
  }

  void _navigateToQRScanner() async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    _swipeAnimationController.stop();
    _qrPulseController.stop();

    await _slideUpController.forward();

    if (mounted) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Qrscreen(),
          transitionDuration: Duration.zero,
        ),
      );
      _resetAnimations();
    }
  }

  void _resetAnimations() {
    if (mounted) {
      setState(() => _isNavigating = false);
      _slideUpController.reset();
      _swipeAnimationController.repeat(reverse: true);
      _qrPulseController.repeat(reverse: true);
    }
  }

  void _toggleInfo() {
    setState(() => _showInfo = !_showInfo);
    if (_showInfo) {
      _infoFadeController.forward();
    } else {
      _infoFadeController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _slideUpController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideUpAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.seaGreenColor,
                      AppColors.bgColor,
                      AppColors.lightYellowColor.withOpacity(0.3),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      // ── Main content ──────────────────────────────────
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 3.h),

                                    // Logo
                                    Center(
                                      child: SizedBox(
                                        height: 9.h,
                                        child: Image.asset(
                                            AppImages.splashScreenLogo),
                                      ),
                                    ),

                                    SizedBox(height: 5.h),

                                    // Center content expands to fill remaining space
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          // ── Animated QR Icon ──────────
                                          GestureDetector(
                                            onTap: _navigateToQRScanner,
                                            child: AnimatedBuilder(
                                              animation: _qrPulseAnimation,
                                              builder: (context, child) {
                                                return Transform.scale(
                                                  scale:
                                                  _qrPulseAnimation.value,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      // Pulse rings
                                                      ...List.generate(3,
                                                              (index) {
                                                            return Container(
                                                              width: (45 +
                                                                  index * 10)
                                                                  .w,
                                                              height: (45 +
                                                                  index * 10)
                                                                  .w,
                                                              decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                BoxShape.circle,
                                                                border: Border.all(
                                                                  color: AppColors
                                                                      .greenColor
                                                                      .withOpacity(
                                                                      0.3 -
                                                                          index *
                                                                              0.1),
                                                                  width: 2,
                                                                ),
                                                              ),
                                                            );
                                                          }),

                                                      // QR container
                                                      Container(
                                                        width: 45.w,
                                                        height: 45.w,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(25),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppColors
                                                                  .greenColor
                                                                  .withOpacity(
                                                                  0.4),
                                                              blurRadius: 30,
                                                              spreadRadius: 5,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .qr_code_scanner_rounded,
                                                          size: 25.w,
                                                          color: AppColors
                                                              .greenColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          SizedBox(height: 6.h),

                                          // ── Swipe Arrow ───────────────
                                          GestureDetector(
                                            onVerticalDragUpdate: (details) {
                                              if (details.delta.dy < -5 &&
                                                  !_isNavigating) {
                                                _navigateToQRScanner();
                                              }
                                            },
                                            onTap: _navigateToQRScanner,
                                            child: AnimatedBuilder(
                                              animation: _swipeAnimation,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(
                                                      0,
                                                      -_swipeAnimation
                                                          .value),
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.all(4.w),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .greenColor
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.arrow_upward_rounded,
                                                      size: 32.sp,
                                                      color:
                                                      AppColors.greenColor,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          SizedBox(height: 3.h),

                                          // ── Labels ────────────────────
                                          CustomText(
                                            text: 'Swipe up to scan QR code',
                                            style: basicColorBold(
                                                20, AppColors.greenColor),
                                          ),

                                          SizedBox(height: 1.h),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: CustomText(
                                              text:
                                              'Scan the QR code to login securely',
                                              style: basicColor(
                                                  15, AppColors.greenColor),
                                              align: TextAlign.center,
                                            ),
                                          ),

                                          SizedBox(height: 4.h),

                                          // ── Instructions toggle ───────
                                          GestureDetector(
                                            onTap: _toggleInfo,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                CustomText(
                                                  text:
                                                  'QR Download Instructions',
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontFamily: "Ubuntu",
                                                    color:
                                                    AppColors.greenColor,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                    AppColors.greenColor,
                                                  ),
                                                  align: TextAlign.center,
                                                ),
                                                SizedBox(width: 2.w),
                                                Container(
                                                  padding:
                                                  EdgeInsets.all(1.5.w),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.greenColor
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    _showInfo
                                                        ? Icons.close
                                                        : Icons.info_outline,
                                                    color: AppColors.greenColor,
                                                    size: 17.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 4.h),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // ── Info Panel Overlay ────────────────────────────
                      if (_showInfo)
                        FadeTransition(
                          opacity: _infoFadeAnimation,
                          child: Container(
                            height: 100.h,
                            color: Colors.black.withOpacity(0.85),
                            child: SafeArea(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 7.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 2.h),

                                    // Header
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.greenColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.qr_code_2_rounded,
                                            color: AppColors.greenColor,
                                            size: 24.sp,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: CustomText(
                                            text: 'How to Get Your QR Code',
                                            style: basicColorBold(
                                                22, AppColors.greenColor),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 3.h),

                                    // Steps container
                                    Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                        BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.greenColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          _buildStepItem(
                                            stepNumber: '1',
                                            icon: Icons.computer_rounded,
                                            title: 'Open Web App',
                                            description:
                                            'Login to the Nizaam by Savviyons web application using your credentials',
                                          ),
                                          SizedBox(height: 2.h),
                                          _buildDivider(),
                                          SizedBox(height: 2.h),
                                          _buildStepItem(
                                            stepNumber: '2',
                                            icon: Icons.settings_rounded,
                                            title: 'Go to Settings',
                                            description:
                                            'Navigate to Settings from the main menu',
                                          ),
                                          SizedBox(height: 2.h),
                                          _buildDivider(),
                                          SizedBox(height: 2.h),
                                          _buildStepItem(
                                            stepNumber: '3',
                                            icon: Icons.apartment_rounded,
                                            title: 'Society Settings',
                                            description:
                                            'Select "Society Settings" from the settings menu',
                                          ),
                                          SizedBox(height: 2.h),
                                          _buildDivider(),
                                          SizedBox(height: 2.h),
                                          _buildStepItem(
                                            stepNumber: '4',
                                            icon: Icons.download_rounded,
                                            title: 'Download QR Code',
                                            description:
                                            'Find and download your unique society QR code',
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 3.h),

                                    // Important note
                                    Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.15),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                          Colors.orange.withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.orange,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: 'Important Note',
                                                  style: basicColorBold(
                                                      16, Colors.orange),
                                                ),
                                                SizedBox(height: 0.5.h),
                                                CustomText(
                                                  text:
                                                  'Each society has a unique QR code. Make sure you download the correct QR code for your society.',
                                                  style: basicColor(
                                                      15, Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 3.h),

                                    // Close button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _toggleInfo,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.greenColor,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: CustomText(
                                          text: 'Got it!',
                                          style: basicColorBold(
                                              16, Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepItem({
    required String stepNumber,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: AppColors.greenColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.greenColor.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: CustomText(
              text: stepNumber,
              style: basicColorBold(18, Colors.white),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.greenColor, size: 20.sp),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: CustomText(
                      text: title,
                      style: basicColorBold(17, Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.8.h),
              CustomText(
                text: description,
                style: basicColor(15, Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.only(left: 5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.greenColor.withOpacity(0.0),
            AppColors.greenColor.withOpacity(0.3),
            AppColors.greenColor.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}