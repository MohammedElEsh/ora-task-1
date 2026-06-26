import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';

class ScanQrButton extends StatefulWidget {
  final VoidCallback onTap;

  const ScanQrButton({
    super.key,
    required this.onTap,
  });

  @override
  State<ScanQrButton> createState() => _ScanQrButtonState();
}

class _ScanQrButtonState extends State<ScanQrButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 140.r,
          height: 140.r,
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isPressed
                  ? [
                      const Color(0xFF1E3A8A),
                      const Color(0xFF1E40AF),
                      const Color(0xFF2563EB),
                    ]
                  : [
                      const Color(0xFF1E40AF),
                      const Color(0xFF2563EB),
                      const Color(0xFF3B82F6),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isPressed ? 0.3 : 0.5),
                blurRadius: _isPressed ? 16 : 24,
                spreadRadius: -2,
                offset: Offset(0, _isPressed ? 4 : 8),
              ),
            ],
          ),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 64.r,
          ),
        ),
      ),
    );
  }
}
