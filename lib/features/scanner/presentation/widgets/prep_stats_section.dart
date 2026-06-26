import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import 'stat_card.dart';

class PrepStatsSection extends StatelessWidget {
  final int totalTickets;
  final int usedTickets;
  final int availableTickets;

  const PrepStatsSection({
    super.key,
    required this.totalTickets,
    required this.usedTickets,
    required this.availableTickets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Statistics',
          style: AppTypography.semiBold16.copyWith(color: AppColors.grey900),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total',
                value: '$totalTickets',
                icon: Icons.confirmation_number_rounded,
                color: AppColors.primary,
                bgColor: AppColors.primary10,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: 'Used',
                value: '$usedTickets',
                icon: Icons.check_circle_rounded,
                color: AppColors.validGreen,
                bgColor: AppColors.success10,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: 'Available',
                value: '$availableTickets',
                icon: Icons.event_available_rounded,
                color: AppColors.warning,
                bgColor: AppColors.warning10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
