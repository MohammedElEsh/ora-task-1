import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final double borderRadius;
  final Color backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurSigma = 12,
    this.borderRadius = 16,
    this.backgroundColor = const Color(0x0FFFFFFF),
    this.borderColor,
    this.padding = EdgeInsets.zero,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: 1)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
