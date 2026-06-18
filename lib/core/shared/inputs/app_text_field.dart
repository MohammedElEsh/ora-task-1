import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.hint,
    this.label,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.isPassword = false,
    this.enablePasswordToggle = true,
    this.isLoading = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.validator,
    this.errorText,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.contentPadding,
    this.fillColor,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;

  final String? hint;
  final String? label;
  final String? helperText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final bool isPassword;
  final bool enablePasswordToggle;

  final bool isLoading;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  final int? maxLines;
  final int? minLines;
  final bool expands;

  final List<TextInputFormatter>? inputFormatters;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;

  final String? Function(String?)? validator;
  final String? errorText;

  final Color? cursorColor;
  final double? cursorHeight;
  final double cursorWidth;
  final Radius? cursorRadius;

  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _toggleObscure() {
    setState(() => _obscure = !_obscure);
  }

  Widget? _buildSuffix() {
    if (widget.isLoading) {
      return SizedBox(
        width: 18.r,
        height: 18.r,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (widget.isPassword && widget.enablePasswordToggle) {
      return IconButton(
        onPressed: _toggleObscure,
        icon: Icon(
          _obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
          size: 20.r,
        ),
      );
    }

    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).inputDecorationTheme;

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      initialValue: widget.initialValue,
      obscureText: widget.isPassword ? _obscure : false,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      maxLines: widget.isPassword ? 1 : (widget.maxLines ?? 1),
      minLines: widget.minLines,
      expands: widget.expands,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      validator: widget.validator,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffix(),
        filled: true,
        fillColor: widget.fillColor ?? theme.fillColor,
        contentPadding: widget.contentPadding ?? theme.contentPadding,
        hintStyle: widget.hintStyle ?? theme.hintStyle,
        border: widget.border ?? theme.border,
        enabledBorder: widget.enabledBorder ?? theme.enabledBorder,
        focusedBorder: widget.focusedBorder ?? theme.focusedBorder,
        errorBorder: widget.errorBorder ?? theme.errorBorder,
        focusedErrorBorder: widget.focusedErrorBorder ?? theme.focusedErrorBorder,
        disabledBorder: widget.disabledBorder ?? theme.disabledBorder,
        counterText: '',
      ),
    );
  }
}
