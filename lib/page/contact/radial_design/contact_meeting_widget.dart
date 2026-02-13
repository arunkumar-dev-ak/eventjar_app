import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';

class ContactMeetingSection {
  static Widget buildDynamicMeetingSection(
    MobileContact contact,
    BuildContext context,
    VoidCallback onMeetingClick,
  ) {
    final meeting = contact.activeMeeting;

    if (meeting == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
      child: _buildScheduledMeetingTile(contact, context, onMeetingClick),
    );
  }

  static Widget _buildScheduledMeetingTile(
    MobileContact contact,
    BuildContext context,
    VoidCallback onMeetingClick,
  ) {
    final meeting = contact.activeMeeting!;
    final isConfirmed = meeting.status.toLowerCase() == 'confirmed';

    final dateText = _formatDate(meeting.scheduledAt);
    final timeText = meeting.meetingTime ?? _formatTime(meeting.scheduledAt);

    return GestureDetector(
      onTap: onMeetingClick,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(1.8.hp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isConfirmed
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(2.wp),
          boxShadow: [
            BoxShadow(
              color: isConfirmed
                  ? Colors.green
                  : Colors.orange.withValues(alpha: 0.4),
              blurRadius: 3.wp,
              offset: Offset(0, 0.6.hp),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: Colors.white, size: 5.wp),
            SizedBox(width: 3.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE + BADGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scheduled Meeting',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                      _buildMeetingStatusBadge(meeting.status),
                    ],
                  ),

                  SizedBox(height: 0.7.hp),

                  /// DATE + TIME
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 3.5.wp,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 1.5.wp),
                      Text(
                        dateText,
                        style: TextStyle(color: Colors.white, fontSize: 9.sp),
                      ),
                      SizedBox(width: 4.wp),
                      Icon(
                        Icons.access_time,
                        size: 3.5.wp,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 1.5.wp),
                      Text(
                        timeText,
                        style: TextStyle(color: Colors.white, fontSize: 9.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMeetingStatusBadge(String status) {
    final isConfirmed = status.toLowerCase() == 'confirmed';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
      decoration: BoxDecoration(
        color: isConfirmed ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(3.wp),
      ),
      child: Text(
        isConfirmed ? 'Confirmed' : 'Pending',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 8.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
