import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildCompanySection(Organizer organizer, EventInfo eventInfo) {
  final EventInfoController controller = Get.find();
  final items = <Widget>[];

  // Company Name
  if (organizer.company != null && organizer.company!.isNotEmpty) {
    items.add(
      _infoRow(Icons.business_center, "Company Name", organizer.company!),
    );
  }

  // Contact Number
  if (eventInfo.organizerContactPhone != null &&
      eventInfo.organizerContactPhone!.isNotEmpty &&
      eventInfo.userTicketStatus?.isRegistered == true) {
    if (items.isNotEmpty) {
      items.add(Divider(height: 3.hp, color: Colors.grey.shade300));
    }
    items.add(
      _infoRow(
        Icons.phone,
        "Contact Number",
        eventInfo.organizerContactPhone!,
        onTap: () => _launchURL('tel:${eventInfo.organizerContactPhone}'),
      ),
    );
  }

  // Website
  if (organizer.website != null && organizer.website!.isNotEmpty) {
    if (items.isNotEmpty) {
      items.add(Divider(height: 3.hp, color: Colors.grey.shade300));
    }
    items.add(
      _infoRow(
        Icons.language,
        "Website",
        organizer.website!,
        onTap: () => _launchURL(
          organizer.website!.startsWith('http')
              ? organizer.website!
              : 'https://${organizer.website}',
        ),
      ),
    );
  }

  // LinkedIn
  if (organizer.linkedin != null && organizer.linkedin!.isNotEmpty) {
    if (items.isNotEmpty) {
      items.add(Divider(height: 3.hp, color: Colors.grey.shade300));
    }
    items.add(
      _infoRow(
        Icons.link,
        "LinkedIn",
        organizer.linkedin!,
        onTap: () => _launchURL(
          organizer.linkedin!.startsWith('http')
              ? organizer.linkedin!
              : 'https://${organizer.linkedin}',
        ),
      ),
    );
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: items);
}

Widget _infoRow(
  IconData icon,
  String title,
  String value, {
  VoidCallback? onTap,
}) {
  final content = Row(
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
                color: onTap != null
                    ? AppColors.gradientDarkStart
                    : Colors.grey[700],
                fontWeight: FontWeight.w500,
                decoration: onTap != null ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  if (onTap != null) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: content,
    );
  }

  return content;
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
