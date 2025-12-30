import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BusinessInfoFormElement extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines; // ← ADD THIS
  final int? minLines; // ← ADD THIS

  const BusinessInfoFormElement({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 9.5.sp;
    final List<TextInputFormatter> formatters = inputFormatters ?? [];

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: formatters,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      style: TextStyle(fontSize: defaultFontSize),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: defaultFontSize,
          color: Colors.black.withValues(alpha: 0.6),
        ),
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
      ),
    );
  }
}
