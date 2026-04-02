import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MeetingCardDate extends GetView<MeetingController> {
  final ContactMeeting meeting;
  const MeetingCardDate({super.key, required this.meeting});

  DateTime get _localScheduledAt => meeting.scheduledAt.toLocal();

  String get formattedDate =>
      DateFormat('MMM dd, yyyy').format(_localScheduledAt);
  String get formattedTime => DateFormat('h:mm a').format(_localScheduledAt);
  String get durationText => '${meeting.duration} min';

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 4),
        ),
      ),
      child: Row(
        children: [
          // Calendar Icon
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(width: 3.wp),

          // Date + Time/Duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DATE (Top - Prominent)
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                // TIME + DURATION (Bottom Row)
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg(context),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textSecondary(context),
                          ),
                          SizedBox(width: 2),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6),
                    // Duration Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer, size: 12, color: statusColor),
                          SizedBox(width: 2),
                          Text(
                            durationText,
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
