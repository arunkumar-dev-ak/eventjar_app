import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/app_snackbar.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:eventjar_app/page/event_info/tabs/location/location_page_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildVirtualEventCard({required String platform, String? meetingLink}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          //heading
          buildIconHeaderContainer(
            icon: Icons.monitor,
            color: AppColors.gradientDarkStart,
          ),
          SizedBox(width: 3.wp),
          //Platform
          Text(
            "Platform",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          //Platform badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              platform,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8.5.sp,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 2.hp),
      //button
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: meetingLink != null && meetingLink.isNotEmpty
              ? AppColors.buttonGradient
              : LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: meetingLink != null && meetingLink.isNotEmpty
                ? () => _launchURL(meetingLink)
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.hp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    meetingLink != null && meetingLink.isNotEmpty
                        ? Icons.video_call
                        : Icons.link_off,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 2.wp),
                  Text(
                    meetingLink != null && meetingLink.isNotEmpty
                        ? "Click to Join Meeting"
                        : "Link Not Available Yet",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> _launchURL(String url) async {
  try {
    final Uri uri = Uri.parse(url);
    LoggerService.loggerInstance.dynamic_d("Trying to open: $url");

    if (await canLaunchUrl(uri)) {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        AppSnackbar.error(
          title: "Launch Failed",
          message: "Unable to open the link. Please try again later.",
        );
      }
    } else {
      AppSnackbar.error(
        title: "Invalid Link",
        message: "The provided URL cannot be opened: $url",
      );
    }
  } catch (e) {
    LoggerService.loggerInstance.dynamic_d("Launch error: $e");
    AppSnackbar.error(
      title: "Error",
      message: "An unexpected error occurred while opening the link.",
    );
  }
}
