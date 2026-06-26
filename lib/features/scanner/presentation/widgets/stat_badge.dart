import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/typography/app_typography.dart';

class StatBadge extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final Color bgColor;

  const StatBadge({
    super.key,
    required this.count,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: AppTypography.semiBold14.copyWith(color: color),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              style: AppTypography.regular12.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
