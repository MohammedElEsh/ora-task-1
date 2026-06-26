import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          const BoxShadow(
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
          _BottomIconButton(
            icon: isTorchOn
                ? Icons.flashlight_on_rounded
                : Icons.flashlight_off_rounded,
            label: 'Flash',
            isActive: isTorchOn,
            onTap: onToggleTorch,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$scannedToday',
                style: AppTypography.bold32.copyWith(color: AppColors.grey900),
              ),
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
          _BottomIconButton(
            icon: Icons.grid_view_rounded,
            label: 'Test',
            onTap: onTestTap,
          ),
        ],
      ),
    );
  }
}

class _BottomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomIconButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
}
