/// A single ticket row in the test-QR bottom sheet.
///
/// Shows a small QR thumbnail, code, holder name, ticket type, and
/// a colour-coded status badge (available / used / invalid). Tappable
/// to select this barcode for simulated scanning.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/services/logger/logger_service.dart';
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
    // Determine colour and label based on status string
    final (color, label) = switch (status) {
      'Used' => (AppColors.deniedRed, 'Used'),
      'Not Found' => (AppColors.invalidOrange, 'Invalid'),
      _ => (AppColors.validGreen, 'Available'),
    };

    return GestureDetector(
      onTap: () {
        LoggerService.d('Ticket tapped: code=$code, status=$status', tag: 'TestQrTicketRow');
        onTap(); // triggers Navigator.pop with the code
      },
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey100),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowLight, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Small QR code thumbnail (coloured by status)
            _QrThumb(code: code, color: color),
            SizedBox(width: 14.w),
            // Code + holder name + ticket type
            Expanded(child: _TicketInfo(code: code, holderName: holderName, ticketType: ticketType, color: color, label: label)),
            SizedBox(width: 8.w),
            // Forward arrow hint
            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.grey300, size: 12.r),
          ],
        ),
      ),
    );
  }
}

/// Mini QR code thumbnail with a coloured background.
class _QrThumb extends StatelessWidget {
  final String code;
  final Color color;
  const _QrThumb({required this.code, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      // Light tinted background behind the QR code
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10.r)),
      child: QrImageView(
        data: code,
        version: QrVersions.auto, // auto-size the QR modules
        size: 44.r,
        backgroundColor: Colors.white,
        eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: color),
        dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: color),
      ),
    );
  }
}

/// Ticket info section: code + status badge + holder + type.
class _TicketInfo extends StatelessWidget {
  final String code, holderName, ticketType, label;
  final Color color;
  const _TicketInfo({required this.code, required this.holderName, required this.ticketType, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Code + status badge
        Row(
          children: [
            // Barcode code (e.g. "TKT-001")
            Expanded(child: Text(code, style: AppTypography.semiBold14.copyWith(letterSpacing: 0.5))),
            // Coloured badge: "Available" / "Used" / "Invalid"
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6.r)),
              child: Text(label, style: AppTypography.medium11.copyWith(color: color)),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        // Row 2: Person icon + holder name + ticket type pill
        Row(
          children: [
            Icon(Icons.person_outline_rounded, color: AppColors.grey400, size: 12.r),
            SizedBox(width: 4.w),
            // Holder name (truncated if too long)
            Expanded(child: Text(holderName, style: AppTypography.regular12.copyWith(color: AppColors.grey600), maxLines: 1, overflow: TextOverflow.ellipsis)),
            // Small grey pill showing ticket type
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(color: AppColors.grey50, borderRadius: BorderRadius.circular(4.r)),
              child: Text(ticketType, style: AppTypography.regular10.copyWith(color: AppColors.grey500)),
            ),
          ],
        ),
      ],
    );
  }
}
