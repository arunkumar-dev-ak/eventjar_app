import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget userProfilebuildInfoRow({
  required IconData icon,
  required String label,
  required String value,
  required Color iconColor,
  bool isLink = false,
  int maxLines = 2,
}) {
  // Check if value indicates empty state
  final isEmpty =
      value == "N/A" ||
      value == "Not provided" ||
      value == "Not specified" ||
      value == "No bio added yet" ||
      value == "Availability not set";

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          color: isEmpty
              ? Colors.grey.shade200
              : iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEmpty ? Colors.grey.shade500 : iconColor,
        ),
      ),
      SizedBox(width: 3.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.3.hp),
            Text(
              value,
              style: TextStyle(
                fontSize: 10.sp,
                color: isEmpty
                    ? Colors.grey.shade500
                    : (isLink ? Colors.blue.shade700 : Colors.black87),
                fontWeight: isEmpty ? FontWeight.normal : FontWeight.w600,
                decoration: (isLink && !isEmpty)
                    ? TextDecoration.underline
                    : null,
                fontStyle: isEmpty ? FontStyle.italic : null,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget userProfileBuildChipSection({
  required String label,
  required List<String> chips,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 1.hp),
      Wrap(
        spacing: 2.wp,
        runSpacing: 1.hp,
        children: chips.map((chip) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              chip,
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}
