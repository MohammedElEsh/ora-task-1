import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanOverlay extends StatelessWidget {
  final Color borderColor;

  const ScanOverlay({
    super.key,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanOverlayPainter(
        borderColor: borderColor,
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  final Color borderColor;

  _ScanOverlayPainter({
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final frameWidth = 260.w;
    final frameHeight = 260.w;
    final frameRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(width / 2, height / 2 - 40.h),
        width: frameWidth,
        height: frameHeight,
      ),
      Radius.circular(20.r),
    );

    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, width, height))
      ..addRRect(frameRect);
    canvas.drawPath(
      Path.combine(PathOperation.reverseDifference, overlayPath, Path()),
      Paint()..color = Colors.black.withValues(alpha: 0.45),
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.r;
    canvas.drawRRect(frameRect, borderPaint);

    final cornerLength = 24.r;
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.r
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frameRect.left, frameRect.top),
        width: cornerLength * 2,
        height: cornerLength * 2,
      ),
      0,
      1.5708,
      false,
      cornerPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frameRect.right, frameRect.top),
        width: cornerLength * 2,
        height: cornerLength * 2,
      ),
      4.71239,
      1.5708,
      false,
      cornerPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frameRect.left, frameRect.bottom),
        width: cornerLength * 2,
        height: cornerLength * 2,
      ),
      1.5708,
      1.5708,
      false,
      cornerPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frameRect.right, frameRect.bottom),
        width: cornerLength * 2,
        height: cornerLength * 2,
      ),
      3.14159,
      1.5708,
      false,
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor;
}