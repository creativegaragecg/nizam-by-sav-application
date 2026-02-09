import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/colors.dart';
import '../Constants/images.dart';

class CustomGreenBg extends StatelessWidget {
  const CustomGreenBg({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, // ← Add this too (double protection)
      body: SafeArea(
          child:Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: AppColors.bgColor,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),  // Dark soft shadow
                  blurRadius: 30,                         // Soft blur (like Figma)
                  offset: const Offset(0, 10),            // Shadow drops down
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [

                /// GREEN BOTTOM AREA
                Positioned(
                  left: 0.w,
                  right: 0.w,
                  top: 0.h,
                  child: Image.asset(
                    AppImages.topGreenCurve,
                    fit: BoxFit.fill,
                    height: 44.h,   // This is the magic number — matches Figma perfectly
                  ),

                ),

                /// green area curve line
                Positioned(
                  top: 0.h,
                  left: 0.w,
                  right: 0.w,
                  child: Transform.rotate(
                    angle: 3,
                    child: Image.asset(AppImages.bottomcurve, fit: BoxFit.fill,
                      height: 66.h,
                    ),
                  ),
                ),

                child,




              ],
            ),

          )
      ),
    );

  }
}
