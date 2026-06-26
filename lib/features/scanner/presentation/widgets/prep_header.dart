import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

class PrepHeader extends StatelessWidget {
  const PrepHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 26.r,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gate Scanner',
                style: AppTypography.semiBold20.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Ready to scan tickets',
                style: AppTypography.regular14.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
