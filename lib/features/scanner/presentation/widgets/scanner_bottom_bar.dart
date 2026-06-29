import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

class ScannerBottomBar extends StatelessWidget {
  final bool isTorchOn;
  final int scannedToday;
  final int totalScanned;
  final VoidCallback onToggleTorch;
  final VoidCallback onTestTap;

  const ScannerBottomBar({
    super.key,
    required this.isTorchOn,
    required this.scannedToday,
    required this.totalScanned,
    required this.onToggleTorch,
    required this.onTestTap,
  });

  @override
  Widget build(BuildContext context) {
    LoggerService.d(
      'Building: torch=$isTorchOn, today=$scannedToday, total=$totalScanned',
      tag: 'ScannerBottomBar',
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconBtn(
            icon: isTorchOn
                ? Icons.flashlight_on_rounded
                : Icons.flashlight_off_rounded,
            label: 'Flash',
            isActive: isTorchOn,
            onTap: () {
              LoggerService.d(
                'Flash tapped (current: $isTorchOn)',
                tag: 'ScannerBottomBar',
              );
              onToggleTorch();
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$scannedToday', style: AppTypography.bold32),
              SizedBox(height: 2.h),
              Text(
                'scanned today',
                style: AppTypography.regular12.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '$totalScanned total',
                style: AppTypography.regular10.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
          _iconBtn(
            icon: Icons.grid_view_rounded,
            label: 'Test',
            onTap: () {
              LoggerService.d('Test tapped', tag: 'ScannerBottomBar');
              onTestTap();
            },
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.grey100,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.grey600,
            size: 22.r,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.medium11.copyWith(
              color: isActive ? AppColors.primary : AppColors.grey600,
            ),
          ),
        ],
      ),
    ),
  );
}
