import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  double fontSize;
  Color? color;
  FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lexend(
        color: color ?? Theme.of(context).cardColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
