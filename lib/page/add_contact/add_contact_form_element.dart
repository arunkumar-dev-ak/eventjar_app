import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactFormElement extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode; // ✅ ADDED
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextStyle? labelStyle;
  final int? maxLength;

  const ContactFormElement({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.autovalidateMode, // ✅ ADDED
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.obscureText = false,
    this.labelStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = labelStyle?.fontSize ?? 14.0;
    final List<TextInputFormatter> formatters = inputFormatters ?? [];
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength!));
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      maxLines: maxLines,
      minLines: minLines,
      inputFormatters: formatters,
      obscureText: obscureText,
      style: TextStyle(fontSize: defaultFontSize),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle ?? TextStyle(fontSize: defaultFontSize),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
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
        alignLabelWithHint: maxLines != null && maxLines! > 1,
      ),
    );
  }
}
