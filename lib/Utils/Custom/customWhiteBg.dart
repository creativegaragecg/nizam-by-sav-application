import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/colors.dart';
import '../Constants/images.dart';

class CustomWhiteBgScreen extends StatelessWidget {
  const CustomWhiteBgScreen({super.key, required this.child});
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
              color: AppColors.white,


            ),
            child:                child,


          )
      ),
    );

  }
}
