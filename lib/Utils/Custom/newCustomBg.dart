import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/colors.dart';

// Custom Clipper for the curved bottom effect
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.lineTo(0, 0);

    // Draw top edge
    path.lineTo(size.width, 0);

    // Draw right edge (going down)
    path.lineTo(size.width, size.height - 80);

    // Create the smooth curve at the bottom
    // Control points create the smooth arc
    path.quadraticBezierTo(
      size.width / 2,        // Control point X (middle of width)
      size.height + 20,      // Control point Y (extends below for curve)
      0,                     // End point X (left side)
      size.height - 80,      // End point Y (same as right side)
    );

    // Close the path back to start
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Alternative: More pronounced curve (deeper)
class DeepCurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 100);

    // Deeper curve
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,      // More extension for deeper curve
      0,
      size.height - 100,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Alternative: Custom cubic curve for more control
class SmoothCurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 80);

    // Using cubic bezier for smoother control
    path.cubicTo(
      size.width * 0.75,     // First control point X
      size.height - 20,      // First control point Y
      size.width * 0.25,     // Second control point X
      size.height - 20,      // Second control point Y
      0,                     // End point X
      size.height - 80,      // End point Y
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class NewCustomGreenBg extends StatelessWidget {
  const NewCustomGreenBg({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: AppColors.bgColor,
          ),
          child: Stack(
            children: [
              /// GREEN CURVED AREA WITH SHADOW
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: ClipPath(
                  clipper: CurvedBottomClipper(), // ← The magic happens here!
                  child: Container(

                    height: 47.h,
                    decoration: BoxDecoration(
                      color: AppColors.newGreen,
                      // Add shadow to the container itself
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Your content
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// If you want even better shadow effect, use this version with Material
class NewCustomGreenBgWithShadow extends StatelessWidget {
  const NewCustomGreenBgWithShadow({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          color: AppColors.bgColor,
          child: Stack(
            children: [
              /// GREEN CURVED AREA WITH MATERIAL SHADOW
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Material(
                  elevation: 8, // Material elevation for shadow
                  shadowColor: Colors.black.withOpacity(0.3),
                  color: Colors.transparent,
                  child: ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Container(
                      height:44.h,
                      color: AppColors.newGreen,
                    ),
                  ),
                ),
              ),

              /// Your content
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// BONUS: Version with gradient for more depth
class NewCustomGreenBgGradient extends StatelessWidget {
  const NewCustomGreenBgGradient({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          color: AppColors.bgColor,
          child: Stack(
            children: [
              /// GREEN CURVED AREA WITH GRADIENT
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.newGreen,
                          AppColors.newGreen.withOpacity(0.9),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Your content
              child,
            ],
          ),
        ),
      ),
    );
  }
}