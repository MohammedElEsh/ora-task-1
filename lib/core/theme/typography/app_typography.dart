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
    return GoogleFonts.habibi(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get bold36 =>
      _base(fontSize: 36, fontWeight: FontWeight.w700);

  static TextStyle get bold28 =>
      _base(fontSize: 28, fontWeight: FontWeight.w700);

  static TextStyle get extraBold24 =>
      _base(fontSize: 24, fontWeight: FontWeight.w800);

  static TextStyle get semiBold20 =>
      _base(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get semiBold18 =>
      _base(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get semiBold14 =>
      _base(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get regular14 =>
      _base(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get regular12 =>
      _base(fontSize: 12, fontWeight: FontWeight.w500);
}
