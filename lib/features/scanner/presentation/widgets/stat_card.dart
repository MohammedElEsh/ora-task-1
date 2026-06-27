import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

/// Large stat card shown on the home screen.
/// Displays an icon, a big number, and a label.
class StatCard extends StatelessWidget {
  final String title; // e.g. "Total", "Used", "Available"
  final String value; // the number to display
  final IconData icon; // icon in the coloured circle
  final Color color; // icon/border accent colour
  final Color bgColor; // light background for the icon circle

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
        // Subtle shadow under the card
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coloured icon circle
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(height: 12.h),
          // Big number
          Text(value, style: AppTypography.bold28),
          SizedBox(height: 4.h),
          // Label underneath
          Text(
            title,
            style: AppTypography.regular12.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

/// Compact stat badge used in the test-QR bottom sheet.
/// Shows "count + label" in a rounded coloured container.
class StatBadge extends StatelessWidget {
  final int count; // number to display
  final String label; // e.g. "Available", "Used", "Invalid"
  final Color color; // text + tint colour
  final Color bgColor; // background colour

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
          // Count number
          Text(
            '$count',
            style: AppTypography.semiBold14.copyWith(color: color),
          ),
          SizedBox(width: 4.w),
          // Label (flexible to prevent overflow on long text)
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
