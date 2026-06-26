/// Card that displays event metadata (name, venue, date, time, gate).
/// Used on the home screen to give context about the current scanning session.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

class EventInfoCard extends StatelessWidget {
  final String eventName;
  final String venue;
  final String date;
  final String time;
  final String gateNumber;

  const EventInfoCard({
    super.key,
    required this.eventName,
    required this.venue,
    required this.date,
    required this.time,
    required this.gateNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        // Blue gradient background
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16.r),
        // Glow effect under the card
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: "LIVE EVENT" badge + verified icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'LIVE EVENT',
                  style: AppTypography.medium10.copyWith(
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.verified_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20.r,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Event name (large white text)
          Text(
            eventName,
            style: AppTypography.semiBold20.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          // Venue with location pin icon
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white70,
                size: 14.r,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  venue,
                  style: AppTypography.regular14.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Thin white divider
          Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
          SizedBox(height: 16.h),
          // Date + Time chips
          Row(
            children: [
              _chip(icon: Icons.calendar_today_rounded, label: date),
              SizedBox(width: 12.w),
              _chip(icon: Icons.access_time_rounded, label: time),
            ],
          ),
          SizedBox(height: 10.h),
          // Gate number chip
          _chip(icon: Icons.door_front_door_rounded, label: gateNumber),
        ],
      ),
    );
  }

  /// Small row with an icon + text label (used for date, time, gate)
  Widget _chip({required IconData icon, required String label}) => Row(
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
