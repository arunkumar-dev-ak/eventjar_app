import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialFormElement extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final int? maxLength; // Add maxLength parameter

  const SocialFormElement({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.maxLength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 14.0;
    final List<TextInputFormatter> formatters = inputFormatters ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          inputFormatters: formatters,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          maxLength: maxLength, // Built-in counter
          buildCounter: maxLength != null
              ? (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) {
                  return Text(
                    '$currentLength/$maxLength characters',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.textHint(context),
                    ),
                  );
                }
              : null,
          style: TextStyle(fontSize: defaultFontSize),
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            labelStyle: TextStyle(
              fontSize: defaultFontSize,
              color: AppColors.textPrimary(context).withValues(alpha: 0.6),
            ),
            hintStyle: TextStyle(
              fontSize: defaultFontSize,
              color: AppColors.textHint(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppColors.border(context), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.blue.shade300 : Colors.blue.shade700, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
            ),
            errorStyle: const TextStyle(height: 0),
            counterStyle: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textHint(context),
            ),
          ),
        ),
      ],
    );
  }
}
