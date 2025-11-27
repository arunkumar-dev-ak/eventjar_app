import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/model/event_info/event_attendee_meeting_req_model.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_shimmer.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_req_empty_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionRequestAttendee extends StatelessWidget {
  ConnectionRequestAttendee({super.key});

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final requestState = controller.state.attendeeRequests.value;
      final isLoading = controller.state.attendeeRequestLoading.value;
      final tabIndex = controller.state.selectedAttendeeTab.value;

      if (isLoading) {
        return Center(child: buildRequestAttendeeListShimmer());
      }
      if (requestState == null) {
        return connectionReqEmptyPlaceholder(
          message: tabIndex == 0
              ? "No sent requests."
              : "No received requests.",
          icon: tabIndex == 0
              ? Icons.outbox_outlined
              : Icons.move_to_inbox_outlined,
        );
      }

      // Choose "sent" or "received" based on tab
      final list = tabIndex == 0 ? requestState.sent : requestState.received;

      if (list.isEmpty) {
        return connectionReqEmptyPlaceholder(
          message: tabIndex == 0
              ? "No sent requests."
              : "No received requests.",
          icon: tabIndex == 0
              ? Icons.outbox_outlined
              : Icons.move_to_inbox_outlined,
        );
      }

      return Column(
        children: List.generate(
          list.length,
          (idx) => buildRequestAttendeeListFromModel(
            list[idx],
            isSent: tabIndex == 0 ? true : false,
          ),
        ),
      );
    });
  }
}

Widget buildRequestAttendeeListFromModel(
  AttendeeMeetingRequest req, {
  required bool isSent,
  VoidCallback? onAccept, // Add callbacks for buttons
  VoidCallback? onDecline,
}) {
  final user = isSent ? req.toUser : req.fromUser;
  Color statusColor = getConnectionAttendeeStatusColor(req.status);

  final EventInfoController controller = Get.find();

  return Container(
    margin: EdgeInsets.symmetric(vertical: 0.5.hp),
    padding: EdgeInsets.all(2.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
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
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(getFileUrl(user.avatarUrl!))
              : null,
          child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
              ? Text(
                  user.name.isNotEmpty ? user.name[0] : '?',
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
              Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
              if (user.company != null)
                Text(
                  user.company ?? "",
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey[700]),
                ),
              SizedBox(height: 0.5.hp),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.wp,
                      vertical: 0.5.hp,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.9),
                          statusColor.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      capitalize(req.status),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 7.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.wp),
                  Icon(Icons.calendar_today, size: 8.sp, color: Colors.grey),
                  SizedBox(width: 1.wp),
                  Text(
                    _formatDate(req.createdAt),
                    style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                  ),
                  SizedBox(width: 3.wp),
                  Icon(Icons.timer, size: 8.sp, color: Colors.grey),
                  SizedBox(width: 1.wp),
                  Text(
                    "${req.duration} minutes",
                    style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 1.hp),
              Text(
                "Message:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 8.sp,
                  color: Colors.blue,
                ),
              ),
              Text(
                req.message,
                style: TextStyle(fontSize: 8.sp, color: Colors.black87),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),

              // Conditional Accept/Decline buttons
              if (!isSent && req.status.toLowerCase() == "pending") ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        label: "Accept",
                        icon: Icons.check_circle_outline,
                        gradientColors: [Color(0xFF90CAF9), Color(0xFF64B5F6)],
                        buttonId: "accept_${req.id}",
                        onPressed: () {
                          controller.respondToMeetingRequest(
                            req.id,
                            'accepted',
                            "accept_${req.id}",
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionButton(
                        label: "Decline",
                        icon: Icons.close_outlined,
                        gradientColors: [Color(0xFFE57373), Color(0xFFEF5350)],
                        buttonId: "decline_${req.id}", // NEW: Unique ID
                        onPressed: () {
                          controller.respondToMeetingRequest(
                            req.id,
                            'declined',
                            "decline_${req.id}",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final String buttonId;

  ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.gradientColors,
    required this.buttonId,
  });

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.state.buttonLoadingStates[buttonId] ?? false;

      return Container(
        height: 42,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: loading
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : gradientColors,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (loading ? Colors.grey.shade500 : gradientColors[0])
                  .withValues(alpha: 0.3),
              blurRadius: loading ? 0 : 12,
              offset: loading ? Offset(0, 0) : Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: loading ? null : onPressed,
          icon: loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Icon(icon, size: 18, color: Colors.white),
          label: Text(
            loading ? "Loading..." : label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9.sp,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      );
    });
  }
}

// Helper for formatting ISO date
String _formatDate(DateTime dt) =>
    "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";

Color getConnectionAttendeeStatusColor(String status) {
  final lowerStatus = status.toLowerCase();
  Color statusColor;

  if (lowerStatus == "accepted") {
    statusColor = Colors.green;
  } else if (lowerStatus == "pending") {
    statusColor = Colors.orange;
  } else if (lowerStatus == "declined") {
    statusColor = Colors.red;
  } else {
    statusColor = Colors.grey;
  }

  return statusColor;
}
