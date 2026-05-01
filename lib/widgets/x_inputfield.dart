import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Themed text field — pulls fill, border, and content padding from
/// the global InputDecorationTheme. Keeps the same constructor surface as
/// the original MyTextField so existing screens drop in without changes.
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.enabled = true,
    this.errorText,
    this.onTap,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.singleLineFormatter,
      if (keyboardType == TextInputType.number)
        FilteringTextInputFormatter.digitsOnly,
      ...?inputFormatters,
    ];

    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      enabled: enabled,
      onTap: onTap,
      onChanged: onChanged,
      maxLengthEnforcement: maxLength != null
          ? MaxLengthEnforcement.enforced
          : MaxLengthEnforcement.none,
      decoration: InputDecoration(
        counterText: '',
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: formatters,
    );
  }
}
