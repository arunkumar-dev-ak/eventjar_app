import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCheckoutEventInfo(EventInfo eventInfo, BuildContext context) {
  final CheckoutController controller = Get.find();

  return Container(
    margin: EdgeInsets.only(top: 4.wp, left: 4.wp, right: 4.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue.shade100, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.shade50,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Container(
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50.withValues(alpha: 0.3), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            eventInfo.title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          SizedBox(height: 2.hp),

          // Tags
          // Wrap(
          //   spacing: 2.wp,
          //   runSpacing: 1.hp,
          //   children: [
          //     ...eventInfo.tags.map((tag) => _buildSimpleTag(tag)),
          //     _buildEventModeTag(
          //       eventInfo.isVirtual
          //           ? "Virtual"
          //           : eventInfo.isHybrid
          //           ? "Hybrid"
          //           : "In-Person",
          //     ),
          //   ],
          // ),
          // _buildEventModeTag(
          //   eventInfo.isVirtual
          //       ? "Virtual"
          //       : eventInfo.isHybrid
          //       ? "Hybrid"
          //       : "In-Person",
          // ),
          // SizedBox(height: 2.hp),

          // Location
          _buildInfoRow(
            eventInfo.isVirtual ? Icons.computer : Icons.location_on,
            eventInfo.isVirtual
                ? "Online"
                : eventInfo.venue != null && eventInfo.venue!.isNotEmpty
                ? "${eventInfo.venue}${eventInfo.city != null && eventInfo.city!.isNotEmpty ? ', ${eventInfo.city}' : ''}"
                : "Location not specified",
            eventInfo.isVirtual ? Colors.blue.shade400 : Colors.red.shade400,
          ),

          SizedBox(height: 1.hp),

          // Date & Time
          _buildInfoRow(
            Icons.calendar_today,
            eventInfo.startTime != null && eventInfo.endTime != null
                ? controller.formatEventDateTimeForHome(eventInfo, context)
                : "Date and time to be announced",
            Colors.blue.shade400,
          ),
          SizedBox(height: 1.hp),

          // Attending
          _buildInfoRow(
            Icons.people,
            "${eventInfo.currentAttendees} / ${eventInfo.maxAttendees}",
            Colors.green.shade400,
          ),
        ],
      ),
    ),
  );
}

Widget _buildSimpleTag(String label) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.5.hp),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey.shade300, width: 1),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/*----- Tags ------*/
Widget _buildEventModeTag(String mode) {
  Color bgColor;
  Color borderColor;
  Color textColor;

  switch (mode.toLowerCase()) {
    case 'virtual':
      bgColor = Colors.purple.shade100;
      borderColor = Colors.purple.shade300;
      textColor = Colors.purple.shade700;
      break;
    case 'in-person':
      bgColor = Colors.orange.shade100;
      borderColor = Colors.orange.shade300;
      textColor = Colors.orange.shade700;
      break;
    case 'hybrid':
      bgColor = Colors.teal.shade100;
      borderColor = Colors.teal.shade300;
      textColor = Colors.teal.shade700;
      break;
    default:
      bgColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade300;
      textColor = Colors.grey.shade700;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.5.hp),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: borderColor, width: 1),
    ),
    child: Text(
      mode,
      style: TextStyle(
        color: textColor,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.all(1.5.wp),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
      SizedBox(width: 2.wp),
      Expanded(
        child: Text(
          text,
          style: TextStyle(fontSize: 9.sp, color: Colors.grey[700]),
        ),
      ),
    ],
  );
}
