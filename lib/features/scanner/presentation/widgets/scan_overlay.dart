import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanOverlay extends StatelessWidget {
  final Color borderColor;
  const ScanOverlay({super.key, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _Painter(borderColor));
  }
}

class _Painter extends CustomPainter {
  final Color color;
  const _Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final frameSize = 260.w;
    final frame = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w / 2, h / 2 - 40.h), width: frameSize, height: frameSize),
      Radius.circular(20.r),
    );

    final overlay = Path()..addRect(Rect.fromLTWH(0, 0, w, h))..addRRect(frame);
    canvas.drawPath(Path.combine(PathOperation.reverseDifference, overlay, Path()), Paint()..color = Colors.black.withValues(alpha: 0.45));

    final borderPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.r;
    canvas.drawRRect(frame, borderPaint);

    final cornerPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3.r..strokeCap = StrokeCap.round;
    final len = 24.r;

    canvas.drawArc(Rect.fromCenter(center: Offset(frame.left, frame.top), width: len * 2, height: len * 2), 0, 1.5708, false, cornerPaint);
    canvas.drawArc(Rect.fromCenter(center: Offset(frame.right, frame.top), width: len * 2, height: len * 2), 4.71239, 1.5708, false, cornerPaint);
    canvas.drawArc(Rect.fromCenter(center: Offset(frame.left, frame.bottom), width: len * 2, height: len * 2), 1.5708, 1.5708, false, cornerPaint);
    canvas.drawArc(Rect.fromCenter(center: Offset(frame.right, frame.bottom), width: len * 2, height: len * 2), 3.14159, 1.5708, false, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _Painter old) => old.color != color;
}
