import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customBgScreen.dart';
import 'package:savvyions/screens/AuthScreens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/styles.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Custom/custom_text.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Qrscreen extends StatefulWidget {
  Qrscreen({super.key, this.isLogin});
  bool? isLogin;

  @override
  State<Qrscreen> createState() => _QrscreenState();
}

class _QrscreenState extends State<Qrscreen> with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Scanning line animation
    _scanLineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scanLineController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleQRCodeDetection(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isEmpty) return;

    final String? rawCode = barcodes.first.rawValue;

    if (rawCode == null || rawCode.isEmpty) return;

    print("Scanned QR Code:\n$rawCode");

    // Split the QR code content by lines
    List<String> lines = rawCode.split('\n').map((line) => line.trim()).toList();

    // Create a map to store parsed values
    String? societyName;
    String? societyId;
    String? baseUrl;

    for (String line in lines) {
      if (line.startsWith('Society Name:')) {
        societyName = line.replaceFirst('Society Name:', '').trim();
      } else if (line.startsWith('Society ID:')) {
        societyId = line.replaceFirst('Society ID:', '').trim();
      } else if (line.startsWith('URL:')) {
        baseUrl = line.replaceFirst('URL:', '').trim();

        // Ensure URL ends with / and has /api/ if needed
        if (!baseUrl.endsWith('/')) {
          baseUrl = '$baseUrl/';
        }
        // Assuming your API is always at /api/
        if (!baseUrl.endsWith('/api/')) {
          baseUrl = '${baseUrl}api/';
        }
      }
    }

    // Validate required fields
    if (societyId == null || baseUrl == null) {
      // Show error toast or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid QR code format')),
      );
      return;
    }

    // Now update the global base URL dynamically
    AppEndPoints.baseUrl = "$baseUrl";
    print('Updated base URL: ${AppEndPoints.baseUrl}'); // Should show new URL

    // Optional: Save society name/id if needed in app state (e.g., SharedPreferences, Provider, etc.)

    // Stop camera
    await _controller.stop();

    // Navigate to login screen with societyId (or pass all data if needed)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          id: societyId,
          societyName: societyName,
          baseUrl: baseUrl, // optional
          // baseUrl: baseUrl, // optional, since it's now global
        ),
      ),
    );
  }

  saveQRInfo() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("qrScanned", true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: SafeArea(
        child: Column(
          children: [
            // Header with back button and logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  if (widget.isLogin == true)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.greenColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    height: 9.h,
                    child: Image.asset(AppImages.splashScreenLogo),
                  ),
                  const Spacer(),
                  if (widget.isLogin == true) SizedBox(width: 10.w),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Title
            CustomText(
              text: "Scan QR Code",
              style: basicColorBold(22, AppColors.greenColor),
            ),

            SizedBox(height: 1.h),

            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomText(
                text: "Position the QR code within the frame to scan",
                style: basicColor(15, Colors.black),
                align: TextAlign.center,
              ),
            ),

            SizedBox(height: 0.h),

            // QR Scanner Frame
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Scanner container
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.greenColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: MobileScanner(
                        onDetect: _handleQRCodeDetection,
                        controller: _controller,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Corner brackets
                  Positioned(
                    width: 70.w,
                    height: 70.w,
                    child: Stack(
                      children: [
                        // Top-left corner
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.greenColor, width: 4),
                                left: BorderSide(color: AppColors.greenColor, width: 4),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        // Top-right corner
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.greenColor, width: 4),
                                right: BorderSide(color: AppColors.greenColor, width: 4),
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        // Bottom-left corner
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.greenColor, width: 4),
                                left: BorderSide(color: AppColors.greenColor, width: 4),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        // Bottom-right corner
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.greenColor, width: 4),
                                right: BorderSide(color: AppColors.greenColor, width: 4),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Animated scanning line
                  Container(
                    width: 70.w,
                    height: 70.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AnimatedBuilder(
                        animation: _scanLineAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              Positioned(
                                top: _scanLineAnimation.value * (70.w - 4),
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.greenColor,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.greenColor.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Instructions
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.greenColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.greenColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.greenColor,
                    size: 21.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: CustomText(
                      text: "Ensure the QR code is clear and well-lit for best results",
                      style: basicColor(14, AppColors.greenColor),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}