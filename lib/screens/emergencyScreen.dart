import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/images.dart';
import 'package:savvyions/Utils/Constants/styles.dart';
import 'package:savvyions/Utils/Custom/custom_text.dart';
import 'dart:async';
import '../providers/auth_provider.dart';

class EmergencySOSScreen extends StatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _pollingTimer;

  bool isEmergencyDeclared = false;
  bool soundEnabled = true;
  double _swipePosition = 0.0;
  bool _isLocked = false; // New: Track if page is locked

  @override
  void initState() {
    super.initState();

    // Pulse animation for SOS button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation for emergency icon
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Shimmer animation for swipe button
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _shimmerController.dispose();
    _audioPlayer.dispose();
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _playEmergencySound() async {
    if (soundEnabled) {
      try {
        await _audioPlayer.play(AssetSource('sounds/mixkit-classic-alarm-995.wav'));
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.setVolume(1.0);
      } catch (e) {
        print('Error playing sound: $e');
      }
    }
  }

  Future<void> _stopEmergencySound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  void _startPollingAcknowledgement() {
    // Poll every 3 seconds to check acknowledgement status
    _pollingTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final authProvider = Provider.of<AuthViewModel>(context, listen: false);
      await authProvider.emergencyAcknowledge(context);

      // Check if data is null or empty - means emergency is resolved
      final acknowledgeData = authProvider.acknowledgeModel?.data;

      if (acknowledgeData == null || acknowledgeData.isEmpty) {
        // Emergency resolved - unlock and allow closing
        setState(() {
          _isLocked = false;
        });
        timer.cancel();
        _showEmergencyResolvedDialog();
      }
    });
  }

  void _showEmergencyResolvedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 2.w),
            CustomText(
              text: 'Emergency Resolved',
              style: basicColorBold(18, Colors.black87),
            ),
          ],
        ),
        content: CustomText(
          text: 'Your emergency has been acknowledged. You can now exit safely.',
          style: basicColor(15, Colors.black87),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close emergency screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: CustomText(
              text: 'Exit',
              style: basicColorBold(15, Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _declareEmergency() {
    setState(() {
      isEmergencyDeclared = true;
      _isLocked = true; // Lock the page
    });

    // Start rotation animation
    _rotationController.repeat();
    _shimmerController.stop();

    // Play emergency sound
    _playEmergencySound();

    // Send emergency alert
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Provider.of<AuthViewModel>(context, listen: false).hitEmergency();

        // Start polling for acknowledgement after emergency is sent
        _startPollingAcknowledgement();
      }
    });
  }

  void _cancelEmergency() {
    // Only allow cancel if not locked
    if (_isLocked) {
      _showLockedMessage();
      return;
    }

    setState(() {
      isEmergencyDeclared = false;
      _swipePosition = 0.0;
    });

    // Stop sound and animations
    _stopEmergencySound();
    _rotationController.reset();
    _shimmerController.repeat();
    _pollingTimer?.cancel();

    Navigator.pop(context);
  }

  void _showLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.lock, color: Colors.white, size: 20),
            SizedBox(width: 2.w),
            Expanded(
              child: CustomText(
                text: 'Emergency active! Please wait for acknowledgement before exiting.',
                style: basicColor(14, Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button if locked
      onWillPop: () async {
        if (_isLocked) {
          _showLockedMessage();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 9.h,
                    child: Image.asset(AppImages.splashScreenLogo),
                  ),
                ),
                SizedBox(height: 4.h),

                // Context-aware greeting
                if (!isEmergencyDeclared)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Stay Safe, Stay Protected',
                              align: TextAlign.center,
                              style: basicColorBold(16, AppColors.greenColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        CustomText(
                          text: 'In case of emergency, swipe below to instantly alert your emergency contacts and local authorities.',
                          style: basicColor(14, Colors.black54),
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.emergency, color: Colors.red, size: 32.sp),
                        SizedBox(height: 1.h),
                        CustomText(
                          text: 'EMERGENCY ACTIVE',
                          style: basicColorBold(17, Colors.red),
                        ),
                        SizedBox(height: 0.5.h),
                        Center(
                          child: CustomText(
                            text: _isLocked
                                ? 'Waiting for acknowledgement...'
                                : 'Help is on the way. Stay calm and safe.',
                            style: basicColor(14.5, Colors.red.shade700),
                          ),
                        ),
                      /*  if (_isLocked) ...[
                          SizedBox(height: 2.h),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          SizedBox(height: 1.h),
                          CustomText(
                            text: '🔒 Page locked until emergency is resolved',
                            style: basicColor(13, Colors.red.shade600),
                          ),
                        ],*/
                      ],
                    ),
                  ),

                SizedBox(height: 2.h),

                // SOS Button with Animation
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated SOS Button (unchanged)
                        if (!isEmergencyDeclared)
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer pulse rings
                                  ...List.generate(3, (index) {
                                    return ScaleTransition(
                                      scale: Tween<double>(begin: 0.8, end: 1.4).animate(
                                        CurvedAnimation(
                                          parent: _pulseController,
                                          curve: Interval(index * 0.2, 1.0, curve: Curves.easeOut),
                                        ),
                                      ),
                                      child: Container(
                                        width: 60.w,
                                        height: 60.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.red.withOpacity(0.4 - index * 0.1),
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  // Main SOS button
                                  Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.red.shade400,
                                            Colors.red.shade700,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red,
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'SOS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.sp,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 4,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                        // Animated Emergency Active Indicator (keep existing code)
                        if (isEmergencyDeclared)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Keep all your existing emergency active animations
                                  ...List.generate(4, (index) {
                                    final delay = index * 0.15;
                                    return ScaleTransition(
                                      scale: Tween<double>(begin: 0.9, end: 2.0).animate(
                                        CurvedAnimation(
                                          parent: _pulseController,
                                          curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
                                        ),
                                      ),
                                      child: FadeTransition(
                                        opacity: Tween<double>(begin: 0.7, end: 0.0).animate(
                                          CurvedAnimation(
                                            parent: _pulseController,
                                            curve: Interval(delay, 1.0, curve: Curves.easeOut),
                                          ),
                                        ),
                                        child: Container(
                                          width: 60.w,
                                          height: 60.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 5 - index * 0.8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  Transform.scale(
                                    scale: 1.0 + (_pulseController.value * 0.3),
                                    child: Container(
                                      width: 45.w,
                                      height: 45.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.withOpacity(0.4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.9),
                                            blurRadius: 50,
                                            spreadRadius: _pulseController.value * 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  RotationTransition(
                                    turns: Tween<double>(begin: 0, end: 1).animate(
                                      CurvedAnimation(
                                        parent: _pulseController,
                                        curve: Curves.linear,
                                      ),
                                    ),
                                    child: Container(
                                      width: 38.w,
                                      height: 38.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.4),
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.red.shade400,
                                            Colors.red.shade700,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red,
                                            blurRadius: 35,
                                            spreadRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          _isLocked ? Icons.lock : Icons.warning_rounded,
                                          color: Colors.white,
                                          size: 28.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                        SizedBox(height: 5.h),

                        if (!isEmergencyDeclared)
                          Column(
                            children: [
                              CustomText(
                                text: 'Emergency Assistance',
                                style: basicColorBold(17, AppColors.greenColor),
                              ),
                              SizedBox(height: 1.h),
                              Center(
                                child: CustomText(
                                  text: 'Swipe below to activate emergency protocol',
                                  style: basicColor(14, Colors.black54),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Sound Toggle (only show if not locked)
                if (!isEmergencyDeclared && !_isLocked)
                  Container(
                    height: 7.h,
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: soundEnabled ? AppColors.greenColor : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: soundEnabled
                                    ? AppColors.greenColor.withOpacity(0.1)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                                  color: soundEnabled ? AppColors.greenColor : Colors.grey,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            CustomText(
                              text: 'Emergency Alarm Sound',
                              style: basicColor(
                                15,
                                soundEnabled ? AppColors.greenColor : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: soundEnabled,
                          onChanged: (value) {
                            setState(() {
                              soundEnabled = value;
                            });
                          },
                          activeColor: AppColors.greenColor,
                        ),
                      ],
                    ),
                  ),

                // Swipe to Emergency or Cancel Button
                if (!isEmergencyDeclared)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxSwipe = constraints.maxWidth - 15.w - 1.h;

                      return GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _swipePosition = (_swipePosition + details.delta.dx)
                                .clamp(0.0, maxSwipe);
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          if (_swipePosition > maxSwipe * 0.8) {
                            _declareEmergency();
                          } else {
                            setState(() {
                              _swipePosition = 0.0;
                            });
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            final progress = _swipePosition / maxSwipe;

                            return Container(
                              height: 7.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color.lerp(Colors.transparent, AppColors.greenColor, progress)!,
                                  ],
                                  stops: [0.0, progress.clamp(0.0, 1.0)],
                                ),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.greenColor,
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  if (_swipePosition == 0)
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: ShaderMask(
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withOpacity(0.3),
                                                Colors.transparent,
                                              ],
                                              stops: [
                                                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                                                _shimmerAnimation.value.clamp(0.0, 1.0),
                                                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                                              ],
                                            ).createShader(bounds);
                                          },
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                  Center(
                                    child: CustomText(
                                      text: progress > 0.5
                                          ? 'Release to launch!'
                                          : 'Swipe to launch Emergency',
                                      style: basicColor(
                                        15,
                                        progress > 0.3 ? Colors.white : AppColors.greenColor,
                                      ),
                                    ),
                                  ),

                                  AnimatedPositioned(
                                    duration: _swipePosition > 0
                                        ? Duration.zero
                                        : Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    left: _swipePosition,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 15.w,
                                      margin: EdgeInsets.all(0.5.h),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: progress > 0.5
                                              ? [Colors.red, Colors.redAccent]
                                              : [AppColors.greenColor, AppColors.greenColor.withOpacity(0.8)],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (progress > 0.5 ? Colors.red : AppColors.greenColor)
                                                .withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                else
                // Cancel button (disabled when locked)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: (_isLocked ? Colors.grey : AppColors.greenColor).withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _cancelEmergency,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLocked ? Colors.grey : AppColors.greenColor,
                        minimumSize: Size(double.infinity, 7.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isLocked ? Icons.lock : Icons.cancel_outlined,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          SizedBox(width: 2.w),
                          CustomText(
                            text: _isLocked ? 'Locked - Awaiting Response' : 'Cancel Emergency',
                            style: basicColorBold(16, Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}