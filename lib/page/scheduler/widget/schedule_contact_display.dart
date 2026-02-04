import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:flutter/material.dart';

Widget buildContactDisplayForSchedulePage(ContactMeeting? meeting) {
  if (meeting == null) {
    return SizedBox.shrink();
  }

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue.shade200),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            meeting.contact?.name?.isNotEmpty == true
                ? meeting.contact!.name![0].toUpperCase()
                : '?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
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
                  color: Colors.black87,
                ),
              ),
              Text(
                meeting.contact?.email ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
