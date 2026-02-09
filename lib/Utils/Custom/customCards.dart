import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';

class CustomCards extends StatelessWidget {
   CustomCards({super.key,this.width, required this.child,this.color,this.radius});
  double? width;
  Color? color;
  final Widget child;
  double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(

      width: width??100.w,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        color: color??Colors.white,
        borderRadius: BorderRadius.circular(radius??15),
        border: Border.all(color:AppColors.cardBorderColor,width: 1 )
      ),
      child: child,
    );
  }
}
