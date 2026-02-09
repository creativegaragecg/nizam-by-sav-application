import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'colors.dart';

/*TextStyle basic(double s) {
  return TextStyle(
    fontSize: s.sp,
    fontFamily: 'Ubuntu',
    color: AppColors.whiteColor,
  );
}*/

/*TextStyle basicBold(double s) {
  return TextStyle(
    fontSize: s.sp,
    fontFamily: 'Ubuntu',
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
  );
}

*/

TextStyle basicColor(double s, Color c) {
  return TextStyle(
    color: c,
    fontSize: s.sp,
    fontFamily: 'Ubuntu',
    fontWeight: FontWeight.w300
  );
}

TextStyle basicColorBold(double s, Color c) {
  return TextStyle(
    color: c,
    fontSize: s.sp,
    fontFamily: 'Ubuntu',
      fontWeight: FontWeight.w700,
  );
}


