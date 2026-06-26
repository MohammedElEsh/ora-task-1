import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';

class TestQrTicketRow extends StatelessWidget {
  final String code;
  final String holderName;
  final String ticketType;
  final String status;
  final VoidCallback onTap;

  const TestQrTicketRow({
    super.key,
    required this.code,
    required this.holderName,
    required this.ticketType,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUsed = status == 'Used';
    final isNotFound = status == 'Not Found';

    Color statusColor;
    String statusLabel;
    if (isUsed) {
      statusColor = AppColors.deniedRed;
      statusLabel = 'Used';
    } else if (isNotFound) {
      statusColor = AppColors.invalidOrange;
      statusLabel = 'Invalid';
    } else {
      statusColor = AppColors.validGreen;
      statusLabel = 'Available';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey100),
          boxShadow: [
            const BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: QrImageView(
                data: code,
                version: QrVersions.auto,
                size: 44.r,
                backgroundColor: Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: statusColor,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: statusColor,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          code,
                          style: AppTypography.semiBold14.copyWith(
                            color: AppColors.grey900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          statusLabel,
                          style: AppTypography.medium11.copyWith(
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.grey400,
                        size: 12.r,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          holderName,
                          style: AppTypography.regular12.copyWith(
                            color: AppColors.grey600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          ticketType,
                          style: AppTypography.regular10.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.grey300,
              size: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}
