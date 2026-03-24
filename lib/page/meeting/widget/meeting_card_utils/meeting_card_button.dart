import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingCardButton extends GetView<MeetingController> {
  final ContactMeeting meeting;
  const MeetingCardButton({super.key, required this.meeting});

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRescheduleLoading =
          controller.state.buttonLoading[meeting.id] == true;
      final isCompleteLoading =
          controller.state.buttonLoading[meeting.id] == true;

      if (meeting.status.toLowerCase() == 'scheduled') {
        // SCHEDULED: Show Action Buttons
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Reschedule Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (isRescheduleLoading || isCompleteLoading) {
                    } else {
                      controller.handleReshedulePage(meeting);
                    }
                  },
                  icon: Icon(
                    Icons.edit_calendar,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                  label: Text('Reschedule', style: TextStyle(fontSize: 8.sp)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: Colors.orange.shade600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              // Complete Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await controller.completeMeeting(meeting.id);
                  },
                  icon: isCompleteLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.check_circle, size: 16, color: Colors.white),
                  label: Text(
                    isCompleteLoading ? 'Completing...' : 'Complete',
                    style: TextStyle(fontSize: 8.sp, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // OTHER STATUS: Show Status Badge
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: statusColor),
                  SizedBox(width: 4),
                  Text(
                    meeting.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (meeting.declineReason != null &&
                meeting.status.toLowerCase() == 'declined')
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    meeting.declineReason!,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.red.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        );
      }
    });
  }
}
