import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicInfoFormElement extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const BasicInfoFormElement({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 14.0;
    final List<TextInputFormatter> formatters = inputFormatters ?? [];

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: formatters,
      style: TextStyle(fontSize: defaultFontSize),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: defaultFontSize),
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
