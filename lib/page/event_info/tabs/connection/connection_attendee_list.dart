import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/event_info/event_attendee_model.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_list_meeting_req_button.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionAttendeeList extends StatelessWidget {
  ConnectionAttendeeList({super.key});

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final attendeeState = controller.state.attendeeList.value;
      final isLoading = controller.state.attendeeListLoading.value;

      if (isLoading) {
        return Center(child: buildAttendeeListShimmer());
      }
      if (attendeeState == null || attendeeState.attendees.isEmpty) {
        return Center(
          child: Text(
            "No attendees found.",
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
          ),
        );
      }

      return Column(
        children: [
          for (final attendee in attendeeState.attendees)
            Padding(
              padding: EdgeInsets.only(bottom: 1.hp),
              child: buildAttendeeInfoCardFromModel(attendee),
            ),
        ],
      );
    });
  }
}

Widget buildAttendeeInfoCardFromModel(
  EventAttendee attendee, {
  VoidCallback? onSendRequest,
}) {
  final EventInfoController controller = Get.find();

  return Container(
    margin: EdgeInsets.symmetric(vertical: 0.5.wp, horizontal: 0.5.wp),
    padding: EdgeInsets.all(1.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.10),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade100,
          backgroundImage: attendee.avatarUrl != null
              ? NetworkImage(getFileUrl(attendee.avatarUrl!))
              : null,
          child: (attendee.avatarUrl == null || attendee.avatarUrl!.isEmpty)
              ? Text(
                  attendee.name.isNotEmpty ? attendee.name[0] : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                )
              : null,
        ),
        SizedBox(width: 4.wp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //name
              Text(
                attendee.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
              SizedBox(height: 0.9.hp),
              //position
              if (((attendee.position != null &&
                      attendee.position!.isNotEmpty) ||
                  (attendee.company != null &&
                      attendee.company!.isNotEmpty))) ...[
                Text(
                  (attendee.position ?? '') +
                      ((attendee.company != null &&
                              attendee.company!.isNotEmpty)
                          ? " at ${attendee.company}"
                          : ""),
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
              ],
              //bio
              if (attendee.bio != null && attendee.bio!.isNotEmpty) ...[
                Text(
                  attendee.bio ?? '',
                  style: TextStyle(fontSize: 7.5.sp, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
              ],
              Obx(() {
                final buttonState = controller.getDynamicButtonState(attendee);

                if (buttonState['text'] == 'Send Meeting Request' ||
                    buttonState['text'] == 'Send Request') {
                  return ConnectionAttendeeListCustomSendButton(
                    label: buttonState['text'],
                    attendeeId: attendee.id,
                    onPressed: () => controller.sendMeetingRequest(
                      attendee.id,
                      attendee.name,
                    ),
                  );
                }

                // ✅ Show BADGE for all other states
                return _buildStatusBadge(
                  text: buttonState['text'],
                  colorType: buttonState['color'],
                );
              }),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatusBadge({required String text, required String colorType}) {
  final colors = _getBadgeColors(colorType);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: colors),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: colors[0].withValues(alpha: 0.3),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 7.5.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
  );
}

List<Color> _getBadgeColors(String colorType) {
  switch (colorType) {
    case 'yellow':
      return [Colors.amber.shade400, Colors.amber.shade600];
    case 'green':
      return [Color(0xFF4CAF50), Color(0xFF45A049)];
    case 'blue':
      return [Colors.blue.shade400, Colors.blue.shade600];
    case 'orange':
      return [Colors.orange.shade400, Colors.orange.shade700];
    case 'grey':
    default:
      return [Colors.grey.shade400, Colors.grey.shade500];
  }
}
