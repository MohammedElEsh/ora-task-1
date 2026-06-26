import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import 'stat_badge.dart';

class TestQrStats extends StatelessWidget {
  final int available;
  final int used;

  const TestQrStats({
    super.key,
    required this.available,
    required this.used,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StatBadge(
              count: available,
              label: 'Available',
              color: AppColors.validGreen,
              bgColor: AppColors.validGreenBg,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: StatBadge(
              count: used,
              label: 'Used',
              color: AppColors.deniedRed,
              bgColor: AppColors.deniedRedBg,
            ),
          ),
          SizedBox(width: 12.w),
          const Expanded(
            child: StatBadge(
              count: 1,
              label: 'Invalid',
              color: AppColors.invalidOrange,
              bgColor: AppColors.invalidOrangeBg,
            ),
          ),
        ],
      ),
    );
  }
}
