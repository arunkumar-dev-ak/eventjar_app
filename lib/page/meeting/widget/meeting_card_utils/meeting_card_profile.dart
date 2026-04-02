import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingCardProfile extends GetView<MeetingController> {
  final ContactMeeting meeting;
  const MeetingCardProfile({super.key, required this.meeting});

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

  String _buildPositionCompany() {
    final contact = meeting.contact!;
    List<String> parts = [];

    if (contact.position != null && contact.position!.isNotEmpty) {
      parts.add(contact.position!);
    }
    if (contact.company != null && contact.company!.isNotEmpty) {
      parts.add(contact.company!);
    }

    return parts.isNotEmpty ? parts.join(' • ') : '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar (UNCHANGED)
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientDarkStart, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(width: 2.wp),

        // ✅ Name → Position@Company (Clear Hierarchy)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. NAME (Bold, prominent)
              Text(
                meeting.contact?.name ?? 'Unknown Contact',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 0.5.hp),
              if (meeting.contact?.position != null ||
                  meeting.contact?.company != null)
                Text(
                  _buildPositionCompany(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              SizedBox(height: 0.2.hp),

              // 3. Scheduled By (if exists)
              if (meeting.scheduledByUser?.name != null)
                Text(
                  'Scheduled by ${meeting.scheduledByUser!.name}',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textHint(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
