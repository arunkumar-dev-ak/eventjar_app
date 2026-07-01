import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/utils/date_utils.dart';
import 'package:eventjar/model/network-meeting/network_meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkMeetingCard extends GetView<MeetingController> {
  final NetworkMeeting meeting;

  const NetworkMeetingCard({super.key, required this.meeting});

  String get contactDisplayName {
    final contact = meeting.contact;
    if (contact == null) return 'unknown_contact'.tr;

    final currentUserId = UserStore.to.profile['id'];
    final user1 = contact.user1;
    final user2 = contact.user2;

    if (user1 == null && user2 == null) {
      return contact.name ?? 'unknown_contact'.tr;
    }

    if (user1 != null && user1['id'] == currentUserId && user2 != null) {
      return user2['name'] ?? contact.name ?? 'unknown_contact'.tr;
    }

    if (user2 != null && user2['id'] == currentUserId && user1 != null) {
      return user1['name'] ?? contact.name ?? 'unknown_contact'.tr;
    }

    return contact.name ?? 'unknown_contact'.tr;
  }

  String get initials {
    final name = contactDisplayName;
    if (name != 'unknown_contact'.tr) {
      return name
          .split(' ')
          .map((n) => n.isNotEmpty ? n[0] : '')
          .take(2)
          .join()
          .toUpperCase();
    }
    return 'NM';
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

  String get durationText => '${meeting.duration} min';

  String _buildPositionCompany() {
    final contact = meeting.contact;
    if (contact == null) return '';
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
    return Card(
      elevation: 2,
      color: AppColors.cardBg(context),
      shadowColor: AppColors.shadow(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(context),
            SizedBox(height: 1.5.hp),
            _buildDate(context),
            SizedBox(height: 1.hp),
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
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            SizedBox(height: 0.5.hp),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contactDisplayName,
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
              if (_buildPositionCompany().isNotEmpty)
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
              if (meeting.scheduledByUser?.name != null)
                Text(
                  '${"scheduled_by".tr} ${meeting.scheduledByUser!.name}',
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

  Widget _buildDate(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (dateText, timeText, timezoneText) = formatUtcToLocal(
      meeting.scheduledAt,
      context,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A3A) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
            ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    dateText,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
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
                            '$timeText $timezoneText',
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

  Widget _buildButtons(BuildContext context) {
    return Obx(() {
      final status = meeting.status.toLowerCase();
      final isButtonLoading =
          controller.state.buttonLoading[meeting.id] == true;

      if (status == 'scheduled') {
        // SCHEDULED: Accept + Reschedule
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isButtonLoading
                      ? null
                      : () => controller.confirmNetworkMeeting(meeting.id),
                  icon: isButtonLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.check, size: 16, color: Colors.white),
                  label: Text(
                    isButtonLoading ? 'confirming'.tr : 'accept'.tr,
                    style: TextStyle(fontSize: 8.sp, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isButtonLoading
                      ? null
                      : () =>
                            controller.handleNetworkMeetingReschedule(meeting),
                  icon: Icon(
                    Icons.edit_calendar,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                  label: Text(
                    'reschedule'.tr,
                    style: TextStyle(fontSize: 8.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: Colors.orange.shade600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (status == 'confirmed') {
        // CONFIRMED: Complete + Reschedule
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isButtonLoading
                      ? null
                      : () async =>
                            await controller.completeNetworkMeeting(meeting.id),
                  icon: isButtonLoading
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
                    isButtonLoading ? 'completing'.tr : 'complete'.tr,
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
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isButtonLoading
                      ? null
                      : () => controller
                            .handleConfirmedMeetingReschedule(meeting),
                  icon: Icon(
                    Icons.edit_calendar,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                  label: Text(
                    'reschedule'.tr,
                    style: TextStyle(fontSize: 8.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: Colors.orange.shade600),
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
                    meeting.status.toLowerCase().tr.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}
