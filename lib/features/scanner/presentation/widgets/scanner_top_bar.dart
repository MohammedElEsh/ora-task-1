import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

class ScannerTopBar extends StatelessWidget {
  final String eventName;
  final String location;
  final int pendingSyncCount;
  final VoidCallback onBack;

  const ScannerTopBar({
    super.key,
    required this.eventName,
    required this.location,
    required this.pendingSyncCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    LoggerService.d('Building: event=$eventName, location=$location, pending=$pendingSyncCount', tag: 'ScannerTopBar');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _BackButton(onTap: onBack),
          SizedBox(width: 12.w),
          Expanded(child: _EventBadge(eventName: eventName, location: location)),
          if (pendingSyncCount > 0) ...[
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(8.r)),
              child: Text('$pendingSyncCount', style: AppTypography.medium12.copyWith(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        LoggerService.d('Back button tapped', tag: 'ScannerTopBar');
        onTap();
      },
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18.r),
      ),
    );
  }
}

class _EventBadge extends StatelessWidget {
  final String eventName;
  final String location;
  const _EventBadge({required this.eventName, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(width: 8.r, height: 8.r, decoration: const BoxDecoration(color: AppColors.badgeOnline, shape: BoxShape.circle)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(eventName, style: AppTypography.semiBold14.copyWith(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.white70, size: 10.r),
                    SizedBox(width: 4.w),
                    Text(location, style: AppTypography.regular11.copyWith(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
