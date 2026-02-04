import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';

class ContactMeetingSection {
  // ✅ MAIN WIDGET - Use this in your accordion
  static Widget buildDynamicMeetingSection(
    MobileContact contact,
    BuildContext context,
    VoidCallback onMeetingClick,
  ) {
    // Hide completely if meeting is completed
    if (contact.meetingCompleted || !contact.meetingScheduled) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildScheduledMeetingTile(contact, context, onMeetingClick),
    );
  }

  // ✅ Scheduled Meeting Tile
  static Widget _buildScheduledMeetingTile(
    MobileContact contact,
    BuildContext context,
    VoidCallback onMeetingClick,
  ) {
    final isConfirmed = contact.meetingConfirmed;

    return GestureDetector(
      onTap: () {
        onMeetingClick();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isConfirmed
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isConfirmed
                  ? Colors.green
                  : Colors.orange.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scheduled Meeting',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      _buildMeetingStatusBadge(contact),
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

  // ✅ Status Badge
  static Widget _buildMeetingStatusBadge(MobileContact contact) {
    String label;
    Color color;

    if (contact.meetingConfirmed) {
      label = 'Confirmed';
      color = Colors.green.shade100;
    } else {
      label = 'Pending';
      color = Colors.orange.shade100;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ✅ Dynamic Meeting Details Popup
  static void _showMeetingDetailsPopup(
    BuildContext context,
    MobileContact contact, {
    VoidCallback? onAcceptMeeting,
    VoidCallback? onMarkComplete,
    VoidCallback? onRescheduleMeeting,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Contact Name
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  contact.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: contact.meetingConfirmed
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        contact.meetingConfirmed
                            ? Icons.check_circle
                            : Icons.pending,
                        color: contact.meetingConfirmed
                            ? Colors.green.shade600
                            : Colors.orange.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        contact.meetingConfirmed
                            ? 'Confirmed'
                            : 'Pending Confirmation',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: contact.meetingConfirmed
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Meeting Details
                if (contact.lastMeetingDate != null) ...[
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    _formatDate(contact.lastMeetingDate!),
                  ),
                  const SizedBox(height: 12),
                ],
                _buildInfoRow(
                  Icons.access_time,
                  'Time',
                  _getMeetingTime(contact),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.email,
                  'Method',
                  _getMeetingMethod(contact),
                ),

                const SizedBox(height: 24),

                // Status Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        contact.meetingConfirmed
                            ? Icons.check_circle
                            : Icons.schedule,
                        color: contact.meetingConfirmed
                            ? Colors.green.shade600
                            : Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          contact.meetingConfirmed
                              ? 'Meeting confirmed! Mark as completed when done.'
                              : 'Awaiting confirmation from contact.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // DYNAMIC ACTION BUTTONS
                Row(
                  children: [
                    if (!contact.meetingConfirmed) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            onAcceptMeeting?.call();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: const Text('Accept Meeting'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: contact.meetingConfirmed
                            ? () {
                                onMarkComplete?.call();
                                Navigator.pop(context);
                              }
                            : () {
                                onRescheduleMeeting?.call();
                                Navigator.pop(context);
                              },
                        icon: Icon(
                          contact.meetingConfirmed
                              ? Icons.task_alt
                              : Icons.refresh,
                          size: 18,
                        ),
                        label: Text(
                          contact.meetingConfirmed
                              ? 'Mark Complete'
                              : 'Reschedule',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Info Row Builder
  static Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ Helper Functions
  static String _formatDate(DateTime date) =>
      '${date.day} ${_getMonth(date.month)}, ${date.year}';

  static String _getMonth(int month) {
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
    return months[month - 1];
  }

  static String _getMeetingMethod(MobileContact contact) {
    final method = contact.customAttributes?['messageSentVia']
        ?.toString()
        .toLowerCase();
    switch (method) {
      case 'email':
        return 'Email';
      case 'whatsapp':
        return 'WhatsApp';
      case 'both':
        return 'Email & WhatsApp';
      default:
        return 'Email';
    }
  }

  static String _getMeetingTime(MobileContact contact) {
    // TODO: Get actual time from API/backend
    return contact.customAttributes?['meetingTime'] ?? '10:30 AM';
  }
}
