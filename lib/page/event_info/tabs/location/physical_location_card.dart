import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';

Widget buildPhysicalEventCard(EventInfo eventInfo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (eventInfo.venue != null && eventInfo.venue!.isNotEmpty) ...[
        _infoRow(Icons.apartment, "Venue", eventInfo.venue!),
        Divider(height: 3.hp, color: Colors.grey.shade300),
      ],
      if (eventInfo.address != null && eventInfo.address!.isNotEmpty) ...[
        _infoRow(Icons.home, "Address", eventInfo.address!),
        Divider(height: 3.hp, color: Colors.grey.shade300),
      ],
      _infoRow(
        Icons.location_on,
        "Location",
        "${eventInfo.city ?? ''}${eventInfo.city != null && eventInfo.state != null ? ', ' : ''}${eventInfo.state ?? ''}${eventInfo.state != null && eventInfo.country != null ? ', ' : ''}${eventInfo.country ?? ''}",
      ),
      if (eventInfo.parkingInfo != null &&
          eventInfo.parkingInfo!.isNotEmpty) ...[
        Divider(height: 3.hp, color: Colors.grey.shade300),
        _infoRow(Icons.local_parking, "Parking", eventInfo.parkingInfo!),
      ],
      if (eventInfo.accessibilityInfo != null &&
          eventInfo.accessibilityInfo!.isNotEmpty) ...[
        Divider(height: 3.hp, color: Colors.grey.shade300),
        _infoRow(
          Icons.accessible,
          "Accessibility",
          eventInfo.accessibilityInfo!,
        ),
      ],
    ],
  );
}

Widget _infoRow(IconData icon, String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.gradientDarkStart, size: 18),
      ),
      SizedBox(width: 3.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 0.5.hp),
            Text(
              value,
              style: TextStyle(
                fontSize: 9.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
