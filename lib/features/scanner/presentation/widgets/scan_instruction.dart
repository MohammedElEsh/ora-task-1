import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/typography/app_typography.dart';

class ScanInstruction extends StatelessWidget {
  const ScanInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Icon(Icons.center_focus_strong_rounded, color: Colors.white70, size: 32.r),
          SizedBox(height: 8.h),
          Text('Align QR code within the frame', style: AppTypography.medium14.copyWith(color: Colors.white70), textAlign: TextAlign.center),
          SizedBox(height: 4.h),
          Text('Hold steady for automatic detection', style: AppTypography.regular12.copyWith(color: Colors.white60), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
