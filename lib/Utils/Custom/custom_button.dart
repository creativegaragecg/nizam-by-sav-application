import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/colors.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color color;
  final String text;
  final TextStyle style;
  final VoidCallback? onPressedCallback;
  final Widget? child;
  final double? borderRadius;
  final Color? borderColor;
  final double? padding;

  const CustomButton({
    this.height,
    this.width,
    required this.color,
    required this.text,
    required this.style,
    this.onPressedCallback,
    this.child,
    this.borderRadius,
    this.borderColor,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
      onTap: onPressedCallback,
      child: Container(
        height: height ?? 6.h,
        width: width ?? 90.w,
        decoration: BoxDecoration(
          // Linear gradient matching Figma design
         color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 30),
          // Drop shadow matching Figma design
        /*  boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),  // Dark soft shadow
              offset: const Offset(0, 4), // Y: 4px offset
              blurRadius: 4, // 10px blur
              spreadRadius: 0, // 0px spread
            ),
          ],*/
          // Border if specified
          border: borderColor != null
              ? Border.all(color: borderColor!.withOpacity(0.2), width: 1)
              : null,
        ),
        child:
        Center(
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}