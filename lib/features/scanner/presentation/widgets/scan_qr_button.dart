/// Large circular scan button with animated press feedback.
///
/// Uses [AnimatedScale] for a subtle press-down effect and [HapticFeedback]
/// on tap. Gradient shifts darker while pressed for extra tactile feel.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';

class ScanQrButton extends StatefulWidget {
  final VoidCallback onTap;
  const ScanQrButton({super.key, required this.onTap});

  @override
  State<ScanQrButton> createState() => _ScanQrButtonState();
}

class _ScanQrButtonState extends State<ScanQrButton> {
  bool _pressed = false; // tracks press state for animation

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // User pressed down → shrink + darken
      onTapDown: (_) {
        LoggerService.d('ScanQrButton pressed down', tag: 'ScanQrButton');
        setState(() => _pressed = true);
      },
      // User lifted finger → trigger haptic + callback + reset
      onTapUp: (_) {
        LoggerService.d('ScanQrButton tapped', tag: 'ScanQrButton');
        setState(() => _pressed = false);
        HapticFeedback.mediumImpact(); // vibration feedback
        widget.onTap();
      },
      // User dragged away → cancel press
      onTapCancel: () {
        LoggerService.d('ScanQrButton press cancelled', tag: 'ScanQrButton');
        setState(() => _pressed = false);
      },
      child: AnimatedScale(
        // Shrink to 90% when pressed, normal when released
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 140.r,
          height: 140.r,
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            // Gradient shifts darker when pressed
            gradient: LinearGradient(
              colors: _pressed
                  ? [const Color(0xFF1E3A8A), const Color(0xFF1E40AF), const Color(0xFF2563EB)]
                  : [const Color(0xFF1E40AF), const Color(0xFF2563EB), const Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(32.r),
            // Shadow shrinks when pressed (button feels "closer" to screen)
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _pressed ? 0.3 : 0.5),
                blurRadius: _pressed ? 16 : 24,
                spreadRadius: -2,
                offset: Offset(0, _pressed ? 4 : 8),
              ),
            ],
          ),
          child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 64.r),
        ),
      ),
    );
  }
}
