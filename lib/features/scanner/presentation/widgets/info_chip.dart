import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/typography/app_typography.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white60, size: 12.r),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTypography.regular12.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
