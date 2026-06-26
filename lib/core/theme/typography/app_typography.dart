import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    double height = 1,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get bold32 =>
      _base(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5);

  static TextStyle get bold28 =>
      _base(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.3);

  static TextStyle get semiBold20 =>
      _base(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2);

  static TextStyle get semiBold18 =>
      _base(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.1);

  static TextStyle get semiBold16 =>
      _base(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get semiBold14 =>
      _base(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get medium14 =>
      _base(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get medium12 =>
      _base(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get medium11 =>
      _base(fontSize: 11, fontWeight: FontWeight.w500);

  static TextStyle get medium10 =>
      _base(fontSize: 10, fontWeight: FontWeight.w500);

  static TextStyle get regular14 =>
      _base(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get regular12 =>
      _base(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle get regular11 =>
      _base(fontSize: 11, fontWeight: FontWeight.w400);

  static TextStyle get regular10 =>
      _base(fontSize: 10, fontWeight: FontWeight.w400);
}
