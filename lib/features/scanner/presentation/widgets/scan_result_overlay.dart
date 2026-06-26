import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../manager/scanner_state.dart';
import 'detail_row.dart';

class ScanResultOverlay extends StatelessWidget {
  final ScannerState state;
  final VoidCallback? onDismiss;

  const ScanResultOverlay({super.key, required this.state, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    if (state is ScannerInitial || state is ScannerLoading) {
      return const SizedBox.shrink();
    }

    final config = _resolveConfig(state);
    if (config == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onDismiss,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: config.accentColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: config.accentColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: config.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    config.icon,
                    color: config.accentColor,
                    size: 24.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        config.title,
                        style: AppTypography.semiBold16.copyWith(
                          color: config.accentColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        config.subtitle,
                        style: AppTypography.regular12.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey300,
                  size: 20.r,
                ),
              ],
            ),
            if (config.showDetails) ...[
              SizedBox(height: 12.h),
              const Divider(color: AppColors.grey100, height: 1),
              SizedBox(height: 12.h),
              _buildDetails(config),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(_ResultConfig config) {
    return Column(
      children: [
        if (config.ticketCode.isNotEmpty)
          DetailRow(
            icon: Icons.confirmation_number_rounded,
            label: 'Ticket Code',
            value: config.ticketCode,
          ),
        if (config.holderName != null) ...[
          SizedBox(height: 8.h),
          DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'Attendee',
            value: config.holderName!,
          ),
        ],
        if (config.ticketType != null) ...[
          SizedBox(height: 8.h),
          DetailRow(
            icon: Icons.local_activity_rounded,
            label: 'Ticket Type',
            value: config.ticketType!,
          ),
        ],
        if (config.timestamp != null) ...[
          SizedBox(height: 8.h),
          DetailRow(
            icon: Icons.access_time_rounded,
            label: 'Scanned at',
            value: config.timestamp!,
          ),
        ],
      ],
    );
  }
}

class _ResultConfig {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final String ticketCode;
  final String? holderName;
  final String? ticketType;
  final String? timestamp;
  final bool showDetails;

  const _ResultConfig({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    this.ticketCode = '',
    this.holderName,
    this.ticketType,
    this.timestamp,
    this.showDetails = true,
  });
}

_ResultConfig? _resolveConfig(ScannerState state) {
  return switch (state) {
    ScanAccepted(:final barcode) => _ResultConfig(
      icon: Icons.check_circle_rounded,
      accentColor: AppColors.validGreen,
      title: 'Entry Allowed',
      subtitle: 'Ticket verified successfully',
      ticketCode: barcode.code,
      holderName: barcode.holderName.isNotEmpty ? barcode.holderName : null,
      ticketType: barcode.ticketType.isNotEmpty ? barcode.ticketType : null,
    ),
    ScanAlreadyUsed(:final barcode) => _ResultConfig(
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.deniedRed,
      title: 'Entry Denied',
      subtitle: 'Ticket already used',
      ticketCode: barcode.code,
      holderName: barcode.holderName.isNotEmpty ? barcode.holderName : null,
      ticketType: barcode.ticketType.isNotEmpty ? barcode.ticketType : null,
      timestamp: barcode.usedAt != null
          ? _formatTimestamp(barcode.usedAt!)
          : null,
    ),
    ScanNotFound(:final code) => _ResultConfig(
      icon: Icons.error_outline_rounded,
      accentColor: AppColors.invalidOrange,
      title: 'Ticket Not Found',
      subtitle: 'No matching ticket in manifest',
      ticketCode: code,
      showDetails: false,
    ),
    ScanError(:final message) => _ResultConfig(
      icon: Icons.error_outline_rounded,
      accentColor: AppColors.deniedRed,
      title: 'Scan Error',
      subtitle: message,
      ticketCode: '',
      showDetails: false,
    ),
    _ => null,
  };
}

String _formatTimestamp(DateTime dt) {
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  final second = dt.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second';
}
