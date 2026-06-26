import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

class TestQrHeader extends StatelessWidget {
  const TestQrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Test Scanner', style: AppTypography.semiBold18),
          SizedBox(height: 6.h),
          Text('Select a ticket to simulate scanning', style: AppTypography.regular14.copyWith(color: AppColors.grey500)),
        ],
      ),
    );
  }
}
