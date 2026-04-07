import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:flutter/material.dart';

Widget buildContactDisplayForSchedulePage(ContactMeeting? meeting) {
  if (meeting == null) {
    return SizedBox.shrink();
  }

  final isDark = AppColors.isDark;
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1A2A3A) : Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? Colors.blue.shade800 : Colors.blue.shade200,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
          child: Text(
            meeting.contact?.name?.isNotEmpty == true
                ? meeting.contact!.name![0].toUpperCase()
                : '?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meeting.contact?.name ?? 'Unknown Contact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryStatic,
                ),
              ),
              Text(
                meeting.contact?.email ?? '',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondaryStatic),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
