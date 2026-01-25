import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScheduleFormElement extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? value;
  final List<TextInputFormatter>? inputFormatters;

  const ScheduleFormElement({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.autovalidateMode,
    this.maxLines = 1,
    this.minLines,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.value,
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
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      maxLines: maxLines,
      minLines: minLines,
      inputFormatters: formatters,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(fontSize: defaultFontSize),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: defaultFontSize),
        suffixIcon: suffixIcon,
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
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        errorStyle: TextStyle(height: 0),
        alignLabelWithHint: maxLines != null && maxLines! > 1,
      ),
    );
  }
}
