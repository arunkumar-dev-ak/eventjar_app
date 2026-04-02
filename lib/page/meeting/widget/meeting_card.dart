import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/page/meeting/widget/meeting_card_utils/meeting_card_button.dart';
import 'package:eventjar/page/meeting/widget/meeting_card_utils/meeting_card_date.dart';
import 'package:eventjar/page/meeting/widget/meeting_card_utils/meeting_card_profile.dart';
import 'package:flutter/material.dart';

class MeetingCard extends StatelessWidget {
  final ContactMeeting meeting;
  final VoidCallback? onReschedule;
  final VoidCallback? onComplete;

  const MeetingCard({
    super.key,
    required this.meeting,
    this.onReschedule,
    this.onComplete,
  });

  String get initials {
    if (meeting.contact?.name != null) {
      return meeting.contact!.name!
          .split(' ')
          .map((n) => n.isNotEmpty ? n[0] : '')
          .take(2)
          .join()
          .toUpperCase();
    }
    return 'CM';
  }

  Color get statusColor {
    switch (meeting.status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue.shade600;
      case 'confirmed':
        return Colors.green.shade600;
      case 'declined':
        return Colors.orange.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      case 'completed':
        return Colors.teal.shade600;
      case 'no_show':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade400;
    }
  }

  String get contactInfo {
    final contact = meeting.contact;
    if (contact == null) return 'No contact';

    List<String> parts = [];
    if (contact.name != null) parts.add(contact.name!);
    if (contact.position != null && contact.company != null) {
      parts.add('${contact.position} at ${contact.company}');
    }
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Contact Info
            MeetingCardProfile(meeting: meeting),

            SizedBox(height: 1.5.hp),

            MeetingCardDate(meeting: meeting),

            SizedBox(height: 1.hp),

            // Notes
            if (meeting.notes != null && meeting.notes!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.chipBg(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  meeting.notes!,
                  style: TextStyle(fontSize: 8.5.sp, color: AppColors.textPrimary(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            SizedBox(height: 0.5.hp),

            MeetingCardButton(meeting: meeting),
          ],
        ),
      ),
    );
  }
}
