import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactFormElement extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextStyle? labelStyle;
  final int? maxLength;
  final IconData? prefixIcon;

  const ContactFormElement({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.obscureText = false,
    this.labelStyle,
    this.prefixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = inputFormatters ?? [];
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 9.sp,
        color: Colors.grey.shade800,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle ??
            TextStyle(
              fontSize: 8.sp,
              color: Colors.grey.shade500,
            ),
        hintStyle: TextStyle(
          fontSize: 8.sp,
          color: Colors.grey.shade400,
        ),
        prefixIcon: prefixIcon != null
            ? Container(
                margin: EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  prefixIcon,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              )
            : null,
        prefixIconConstraints: prefixIcon != null
            ? BoxConstraints(minWidth: 40, minHeight: 40)
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines != null && maxLines! > 1 ? 16 : 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.gradientDarkStart,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        errorStyle: TextStyle(
          fontSize: 7.sp,
          color: Colors.red.shade600,
        ),
        alignLabelWithHint: maxLines != null && maxLines! > 1,
      ),
    );
  }
}
