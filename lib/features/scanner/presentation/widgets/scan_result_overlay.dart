import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../manager/scanner_state.dart';

class ScanResultOverlay extends StatelessWidget {
  final ScannerState state;
  final VoidCallback? onDismiss;

  const ScanResultOverlay({super.key, required this.state, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    // Get the colour/icon/text config for the current state
    final config = _config(state);
    // No config = no result to show (initial/loading state)
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
            color: config.$1.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: config.$1.withValues(alpha: 0.15),
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
                    color: config.$1.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(config.$2, color: config.$1, size: 24.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        config.$3,
                        style: AppTypography.semiBold16.copyWith(
                          color: config.$1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        config.$4,
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
            if (config.$5) ...[
              SizedBox(height: 12.h),
              const Divider(color: AppColors.grey100, height: 1),
              SizedBox(height: 12.h),
              _Details(state: state),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns (colour, icon, title, subtitle, showDetails) for each state.
  (Color, IconData, String, String, bool)? _config(ScannerState s) =>
      switch (s) {
        ScanAccepted() => (
          AppColors.validGreen,
          Icons.check_circle_rounded,
          'Entry Allowed',
          'Ticket verified successfully',
          true,
        ),
        ScanAlreadyUsed() => (
          AppColors.deniedRed,
          Icons.warning_amber_rounded,
          'Entry Denied',
          'Ticket already used',
          true,
        ),
        ScanNotFound() => (
          AppColors.invalidOrange,
          Icons.error_outline_rounded,
          'Ticket Not Found',
          'No matching ticket in manifest',
          false,
        ),
        ScanError(:final message) => (
          AppColors.deniedRed,
          Icons.error_outline_rounded,
          'Scan Error',
          message,
          false,
        ),
        _ => null,
      };
}

/// Detail section showing ticket code, attendee, type, and scan time.
class _Details extends StatelessWidget {
  final ScannerState state;

  const _Details({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      // For accepted / already used — show full ticket details
      ScanAccepted(:final barcode) || ScanAlreadyUsed(:final barcode) => Column(
        children: [
          _row(
            icon: Icons.confirmation_number_rounded,
            label: 'Ticket Code',
            value: barcode.code,
          ),
          // Only show holder name if it's not empty
          if (barcode.holderName.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _row(
              icon: Icons.person_outline_rounded,
              label: 'Attendee',
              value: barcode.holderName,
            ),
          ],
          // Only show ticket type if it's not empty
          if (barcode.ticketType.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _row(
              icon: Icons.local_activity_rounded,
              label: 'Ticket Type',
              value: barcode.ticketType,
            ),
          ],
          // Only show scan time if the barcode was actually used
          if (barcode.isUsed && barcode.usedAt != null) ...[
            SizedBox(height: 8.h),
            _row(
              icon: Icons.access_time_rounded,
              label: 'Scanned at',
              value: _time(barcode.usedAt!),
            ),
          ],
        ],
      ),
      // For not found — just show the scanned code
      ScanNotFound(:final code) => _row(
        icon: Icons.confirmation_number_rounded,
        label: 'Ticket Code',
        value: code,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _row({
    required IconData icon,
    required String label,
    required String value,
  }) => Row(
    children: [
      Icon(icon, color: AppColors.grey400, size: 16.r),
      SizedBox(width: 10.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.medium14.copyWith(color: AppColors.grey800),
          ),
          Text(
            label,
            style: AppTypography.regular11.copyWith(color: AppColors.grey400),
          ),
        ],
      ),
    ],
  );

  /// Formats a DateTime to "HH:MM:SS"
  String _time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
}
