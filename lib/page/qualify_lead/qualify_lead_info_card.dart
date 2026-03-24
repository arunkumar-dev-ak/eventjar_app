// COMMON TEXT FORM FIELD
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget qualifyLeadTextField({
  required TextEditingController controller,
  required String label,
  IconData? prefixIcon,
  TextInputType? keyboardType,
  int maxLines = 1,
  int? minLines,
  int? maxLength,
  String? Function(String?)? validator,
}) {
  final hasValue = controller.text.isNotEmpty;

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    minLines: minLines,
    maxLength: maxLength,
    // expands: maxLines > 1 ? false : true,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: hasValue ? Colors.black : Colors.grey[600],
        fontSize: 9.sp,
      ),
      floatingLabelStyle: TextStyle(
        color: Colors.black,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey[600])
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: EdgeInsets.all(3.wp),
      counterText: '', // Hide counter for single line
    ),
    validator: validator,
    onChanged: (value) {
      // Trigger rebuild when value changes for label color
      controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    },
  );
}

Widget buildLeadCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(3.wp),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.wp),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 2.wp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.hp),
              Text(
                value.isEmpty ? '-' : value,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
