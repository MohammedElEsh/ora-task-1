/// Semi-transparent camera overlay with a transparent cut-out for the scan frame.
///
/// The [borderColor] controls the frame border and corner accent colour —
/// changes to green / red / orange to provide visual scan feedback.
/// Painted via [CustomPaint] for performance.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanOverlay extends StatelessWidget {
  final Color borderColor;
  const ScanOverlay({super.key, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    // Delegate all painting to _Painter for performance
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
    // Size of the scan frame square
    final frameSize = 260.w;

    // Define the scan frame rectangle (centered, slightly above middle)
    final frame = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w / 2, h / 2 - 40.h), // offset up by 40h
        width: frameSize,
        height: frameSize,
      ),
      Radius.circular(20.r),
    );

    // Step 1: Draw the dark overlay everywhere
    // Then subtract the frame area to create a "window"
    final overlay = Path()
      ..addRect(Rect.fromLTWH(0, 0, w, h))  // full screen
      ..addRRect(frame);                       // frame cut-out
    canvas.drawPath(
      // reverseDifference = screen minus frame = overlay with hole
      Path.combine(PathOperation.reverseDifference, overlay, Path()),
      Paint()..color = Colors.black.withValues(alpha: 0.45),
    );

    // Step 2: Draw the thin border around the frame
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.r;
    canvas.drawRRect(frame, borderPaint);

    // Step 3: Draw thick corner arcs for a "viewfinder" look
    final cornerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.r
      ..strokeCap = StrokeCap.round;
    final len = 24.r; // arc radius

    // Top-left corner
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frame.left, frame.top),
        width: len * 2,
        height: len * 2,
      ),
      0,        // start angle
      1.5708,   // sweep = 90 degrees
      false,
      cornerPaint,
    );
    // Top-right corner
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frame.right, frame.top),
        width: len * 2,
        height: len * 2,
      ),
      4.71239,  // 270 degrees
      1.5708,   // sweep = 90 degrees
      false,
      cornerPaint,
    );
    // Bottom-left corner
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frame.left, frame.bottom),
        width: len * 2,
        height: len * 2,
      ),
      1.5708,   // 90 degrees
      1.5708,   // sweep = 90 degrees
      false,
      cornerPaint,
    );
    // Bottom-right corner
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(frame.right, frame.bottom),
        width: len * 2,
        height: len * 2,
      ),
      3.14159,  // 180 degrees
      1.5708,   // sweep = 90 degrees
      false,
      cornerPaint,
    );
  }

  // Only repaint when the border colour changes
  @override
  bool shouldRepaint(covariant _Painter old) => old.color != color;
}
