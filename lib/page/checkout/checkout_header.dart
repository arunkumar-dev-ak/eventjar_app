import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCheckoutEventInfo(EventInfo eventInfo, BuildContext context) {
  final CheckoutController controller = Get.find();

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.all(4.wp),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkStart.withValues(alpha: 0.08),
                  AppColors.gradientDarkEnd.withValues(alpha: 0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Event Icon
                Container(
                  padding: EdgeInsets.all(3.wp),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.event_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Event Details",
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 0.3.hp),
                      Text(
                        eventInfo.title,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Event Details
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Column(
              children: [
                // Location
                _buildInfoRow(
                  icon: eventInfo.isVirtual ? Icons.videocam_rounded : Icons.location_on_rounded,
                  title: eventInfo.isVirtual ? "Virtual Event" : "Location",
                  value: eventInfo.isVirtual
                      ? "Online"
                      : eventInfo.venue != null && eventInfo.venue!.isNotEmpty
                          ? "${eventInfo.venue}${eventInfo.city != null && eventInfo.city!.isNotEmpty ? ', ${eventInfo.city}' : ''}"
                          : "Location not specified",
                  iconColor: eventInfo.isVirtual ? Colors.purple : Colors.red.shade400,
                ),

                SizedBox(height: 1.5.hp),

                // Date & Time
                _buildInfoRow(
                  icon: Icons.calendar_month_rounded,
                  title: "Date & Time",
                  value: eventInfo.startTime != null && eventInfo.endTime != null
                      ? controller.formatEventDateTimeForHome(eventInfo, context)
                      : "Date and time to be announced",
                  iconColor: Colors.blue.shade400,
                ),

                SizedBox(height: 1.5.hp),

                // Attendees
                _buildInfoRow(
                  icon: Icons.groups_rounded,
                  title: "Attendees",
                  value: "${eventInfo.currentAttendees} / ${eventInfo.maxAttendees} registered",
                  iconColor: Colors.green.shade400,
                ),
              ],
            ),
          ),

          // Event Mode Badge
          Container(
            margin: EdgeInsets.only(left: 4.wp, right: 4.wp, bottom: 4.wp),
            child: Row(
              children: [
                _buildEventModeBadge(eventInfo),
                if (eventInfo.tags.isNotEmpty) ...[
                  SizedBox(width: 2.wp),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: eventInfo.tags
                            .take(3)
                            .map((tag) => _buildTagChip(tag))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoRow({
  required IconData icon,
  required String title,
  required String value,
  required Color iconColor,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
      SizedBox(width: 3.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 0.3.hp),
            Text(
              value,
              style: TextStyle(
                fontSize: 9.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildEventModeBadge(EventInfo eventInfo) {
  String mode;
  Color bgColor;
  Color textColor;
  IconData icon;

  if (eventInfo.isVirtual) {
    mode = "Virtual";
    bgColor = Colors.purple.shade50;
    textColor = Colors.purple.shade700;
    icon = Icons.videocam_rounded;
  } else if (eventInfo.isHybrid) {
    mode = "Hybrid";
    bgColor = Colors.teal.shade50;
    textColor = Colors.teal.shade700;
    icon = Icons.sync_rounded;
  } else {
    mode = "In-Person";
    bgColor = Colors.orange.shade50;
    textColor = Colors.orange.shade700;
    icon = Icons.location_on_rounded;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: textColor.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textColor),
        SizedBox(width: 1.5.wp),
        Text(
          mode,
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTagChip(String tag) {
  return Container(
    margin: EdgeInsets.only(right: 2.wp),
    padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.6.hp),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Text(
      tag,
      style: TextStyle(
        fontSize: 7.sp,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
