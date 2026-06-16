import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/typography/app_typography.dart';

/// Visual variant of [AppButton]. Each variant pulls its base style from
/// the matching Material button theme in the active [ThemeData]
/// (see `light_theme.dart` / `dark_theme.dart`).
///
/// The button theme is the single source of truth for the look (color,
/// padding, radius, text style). Change it there to affect every
/// [AppButton] of that variant globally.
///
/// The optional [AppButton.style] parameter is always merged on top of the
/// resolved base style, so a single override can recolor / resize / restyle
/// any variant without duplicating its base look.
enum AppButtonVariant {
  /// Solid background. Resolves to `theme.elevatedButtonTheme.style`.
  elevated,

  /// Transparent background with a colored border.
  /// Resolves to `theme.outlinedButtonTheme.style`.
  outlined,

  /// No background, no border. Resolves to `theme.textButtonTheme.style`.
  text,

  /// Round icon-only button. Resolves to `theme.iconButtonTheme.style`.
  icon,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,

    // required
    required this.label,
    required this.onPressed,
    required this.variant,

    // states
    this.isLoading = false,
    this.enabled = true,

    // icons
    this.prefixIcon,
    this.suffixIcon,

    // layout
    this.expanded = true,
    this.alignment = Alignment.center,

    // sizing
    this.width,
    this.height,
    this.minSize,
    this.maxSize,

    // theme override (safe escape hatch)
    this.style,

    // feedback
    this.autofocus = false,
    this.focusNode,
    this.onLongPress,
    this.onHover,

    // semantics / accessibility
    this.semanticLabel,

    // splash / interaction
    this.enableFeedback = true,
    this.enableHaptic = false,

    // clip behavior
    this.clipBehavior = Clip.none,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  final bool isLoading;
  final bool enabled;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool expanded;
  final Alignment alignment;

  final double? width;
  final double? height;

  final Size? minSize;
  final Size? maxSize;

  final ButtonStyle? style;

  final bool autofocus;
  final FocusNode? focusNode;

  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;

  final String? semanticLabel;

  final bool enableFeedback;
  final bool enableHaptic;

  final Clip clipBehavior;

  bool get _disabled => isLoading || onPressed == null || !enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final baseStyle = _resolveBaseStyle(theme);
    final resolvedStyle = baseStyle?.merge(style) ?? style;

    final fg = resolvedStyle?.foregroundColor?.resolve({}) ??
        _resolveFallbackFg(theme);

    final child = _buildChild(resolvedStyle, fg);

    if (variant == AppButtonVariant.icon) {
      return _buildButton(
        onPressed: _disabled ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        autofocus: autofocus,
        focusNode: focusNode,
        style: resolvedStyle,
        clipBehavior: clipBehavior,
        child: Semantics(
          label: semanticLabel ?? label,
          button: true,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: width ?? (expanded ? double.infinity : null),
      height: height,
      child: _buildButton(
        onPressed: _disabled ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        autofocus: autofocus,
        focusNode: focusNode,
        style: resolvedStyle,
        clipBehavior: clipBehavior,
        child: Semantics(
          label: semanticLabel,
          button: true,
          child: child,
        ),
      ),
    );
  }

  // ── Variant resolution ────────────────────────────────────────────────────
  // Single source of truth: each variant maps to one Material button theme
  // in the active ThemeData. To restyle every button of a kind globally,
  // edit the corresponding `*ButtonTheme` block in light_theme.dart /
  // dark_theme.dart.

  ButtonStyle? _resolveBaseStyle(ThemeData theme) {
    switch (variant) {
      case AppButtonVariant.elevated:
        return theme.elevatedButtonTheme.style;
      case AppButtonVariant.outlined:
        return theme.outlinedButtonTheme.style;
      case AppButtonVariant.text:
        return theme.textButtonTheme.style;
      case AppButtonVariant.icon:
        return theme.iconButtonTheme.style;
    }
  }

  Color _resolveFallbackFg(ThemeData theme) {
    switch (variant) {
      case AppButtonVariant.elevated:
        return theme.colorScheme.onPrimary;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
      case AppButtonVariant.icon:
        return theme.colorScheme.primary;
    }
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required VoidCallback? onLongPress,
    required ValueChanged<bool>? onHover,
    required bool autofocus,
    required FocusNode? focusNode,
    required ButtonStyle? style,
    required Clip clipBehavior,
    required Widget child,
  }) {
    switch (variant) {
      case AppButtonVariant.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style,
          clipBehavior: clipBehavior,
          child: child,
        );
      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style,
          clipBehavior: clipBehavior,
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style,
          clipBehavior: clipBehavior,
          child: child,
        );
      case AppButtonVariant.icon:
        return IconButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style,
          tooltip: semanticLabel,
          icon: child,
        );
    }
  }

  Widget _buildChild(ButtonStyle? resolvedStyle, Color fg) {
    if (variant == AppButtonVariant.icon) {
      if (prefixIcon != null) {
        return IconTheme(
          data: IconThemeData(color: fg, size: 24),
          child: prefixIcon!,
        );
      }
      if (suffixIcon != null) {
        return IconTheme(
          data: IconThemeData(color: fg, size: 24),
          child: suffixIcon!,
        );
      }
      return const SizedBox.shrink();
    }

    if (isLoading) {
      return SizedBox(
        width: 18.r,
        height: 18.r,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: fg,
        ),
      );
    }

    final baseTextStyle =
        resolvedStyle?.textStyle?.resolve({}) ?? AppTypography.semiBold14;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          IconTheme(data: IconThemeData(color: fg), child: prefixIcon!),
          SizedBox(width: 8.w),
        ],
        Text(label, style: baseTextStyle.copyWith(color: fg)),
        if (suffixIcon != null) ...[
          SizedBox(width: 8.w),
          IconTheme(data: IconThemeData(color: fg), child: suffixIcon!),
        ],
      ],
    );
  }
}
