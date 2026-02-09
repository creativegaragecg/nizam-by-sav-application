import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/colors.dart';
import '../Constants/images.dart';

class CustomBgScreen extends StatelessWidget {
  const CustomBgScreen({super.key, required this.child});
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

                // TOP LIGHT CURVE (background pattern)
                Positioned(
                  top: 1.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    AppImages.topCurve,
                    fit: BoxFit.cover,
                    height: 43.h, // Adjust this if needed (50-60.h works best)
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
