import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

enum PrepStatus { initial, downloading, success, error }

class PrepStatusContent extends StatelessWidget {
  final PrepStatus status;
  final double progress;

  const PrepStatusContent({
    super.key,
    required this.status,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case PrepStatus.initial:
        return _buildInitial();
      case PrepStatus.downloading:
        return _buildDownloading();
      case PrepStatus.success:
        return _buildSuccess();
      case PrepStatus.error:
        return _buildError();
    }
  }

  Widget _buildInitial() {
    return Container(
      key: const ValueKey('initial'),
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Download the ticket manifest to start scanning. An internet connection is required.',
              style: AppTypography.regular12.copyWith(
                color: AppColors.grey600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloading() {
    return Container(
      key: const ValueKey('downloading'),
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.r,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Downloading manifest...',
                style: AppTypography.semiBold14.copyWith(
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4.h,
              backgroundColor: AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: AppTypography.regular12.copyWith(color: AppColors.grey400),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      key: const ValueKey('success'),
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.validGreenBg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.validGreen.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.validGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.validGreen,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manifest Ready',
                      style: AppTypography.semiBold16.copyWith(
                        color: AppColors.validGreen,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '15 tickets loaded. Device is ready for scanning.',
                      style: AppTypography.regular12.copyWith(
                        color: AppColors.grey600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.badgeOnlineBg,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.badgeOnline.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: AppColors.badgeOnline, size: 6.r),
              SizedBox(width: 8.w),
              Text(
                'Ready for scanning',
                style: AppTypography.medium12.copyWith(
                  color: AppColors.badgeOnline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      key: const ValueKey('error'),
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.deniedRedBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.deniedRed.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.deniedRed,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download Failed',
                  style: AppTypography.semiBold14.copyWith(
                    color: AppColors.deniedRed,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Could not connect to server. Check your connection and try again.',
                  style: AppTypography.regular12.copyWith(
                    color: AppColors.grey600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
