import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  final TextAlign? align;
  final TextOverflow? overflow;


  const CustomText({
    required this.text,
    required this.style,
    this.align,
    this.overflow,
    super.key,  this.maxLines=20,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: align ?? TextAlign.left,
      overflow: overflow,
      maxLines: maxLines,

    );
  }
}
