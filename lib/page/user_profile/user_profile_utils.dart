import 'package:eventjar/global/app_colors.dart';
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

  return Container(
    padding: EdgeInsets.symmetric(vertical: 1.hp),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.5.wp),
          decoration: BoxDecoration(
            color: isEmpty
                ? Colors.grey.shade100
                : iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isEmpty ? Colors.grey.shade400 : iconColor,
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
                  fontSize: 7.sp,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 0.4.hp),
              Text(
                value,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: isEmpty
                      ? Colors.grey.shade400
                      : (isLink ? AppColors.gradientDarkStart : Colors.grey.shade800),
                  fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
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
    ),
  );
}

Widget userProfileBuildChipSection({
  required String label,
  required List<String> chips,
  Color? chipColor,
}) {
  final colors = [
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.green,
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 8.sp,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 1.hp),
      Wrap(
        spacing: 2.wp,
        runSpacing: 1.hp,
        children: chips.asMap().entries.map((entry) {
          final index = entry.key;
          final chip = entry.value;
          final color = chipColor ?? colors[index % colors.length];

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              chip,
              style: TextStyle(
                fontSize: 7.sp,
                color: color.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

// Compact info row for two-column layout
Widget userProfileBuildCompactRow({
  required IconData icon,
  required String label,
  required String value,
  required Color iconColor,
}) {
  final isEmpty =
      value == "N/A" ||
      value == "Not provided" ||
      value == "Not specified";

  return Row(
    children: [
      Icon(
        icon,
        size: 16,
        color: isEmpty ? Colors.grey.shade400 : iconColor,
      ),
      SizedBox(width: 2.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 6.sp,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 8.sp,
                color: isEmpty ? Colors.grey.shade400 : Colors.grey.shade800,
                fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                fontStyle: isEmpty ? FontStyle.italic : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}

extension ColorShade on Color {
  Color get shade700 {
    return HSLColor.fromColor(this).withLightness(0.35).toColor();
  }
}
