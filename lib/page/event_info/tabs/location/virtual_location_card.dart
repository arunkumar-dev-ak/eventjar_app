import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/tabs/location/location_page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildVirtualEventCard({required String platform, String? meetingLink}) {
  final EventInfoController controller = Get.find();

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
              color: Colors.grey.shade800,
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
                fontSize: 7.5.sp,
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
          gradient: _getButtonGradient(controller, meetingLink),
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
            onTap: _shouldEnableJoinButton(controller, meetingLink)
                ? () => _launchURL(meetingLink!)
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.hp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getJoinButtonIcon(controller, meetingLink),
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 2.wp),
                  Text(
                    _getJoinButtonText(controller, meetingLink),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 8.sp,
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
    AppSnackbar.error(
      title: "Error",
      message: "An unexpected error occurred while opening the link.",
    );
  }
}

/// ✅ GRADIENT: gradientDarkStart base
LinearGradient _getButtonGradient(
  EventInfoController controller,
  String? meetingLink,
) {
  final isEnabled = _shouldEnableJoinButton(controller, meetingLink);

  if (!isEnabled) {
    // DISABLED: Grey overlay
    return LinearGradient(
      colors: [
        AppColors.gradientDarkStart.withValues(alpha: 0.4),
        AppColors.gradientDarkStart.withValues(alpha: 0.2),
      ],
    );
  }

  // ENABLED: Full gradientDarkStart gradient
  return LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
  );
}

/// ✅ 1. Button enabled? (Registered OR Organizer)
bool _shouldEnableJoinButton(
  EventInfoController controller,
  String? meetingLink,
) {
  final eventInfo = controller.state.eventInfo.value;
  if (eventInfo == null || meetingLink == null || meetingLink.isEmpty) {
    return false;
  }

  final isRegistered = eventInfo.userTicketStatus?.isRegistered == true;
  final organizerId = eventInfo.organizer.id;
  final isOrganizer =
      organizerId.isNotEmpty && controller.isOrganizer(organizerId);

  return isRegistered || isOrganizer;
}

/// ✅ 2. VIDEO ICON ONLY
IconData _getJoinButtonIcon(
  EventInfoController controller,
  String? meetingLink,
) {
  if (!_shouldEnableJoinButton(controller, meetingLink)) {
    return Icons.lock_outline; // Disabled
  }
  return Icons.video_call; // ✅ ALWAYS VIDEO ICON
}

/// ✅ 3. Text only changes
String _getJoinButtonText(EventInfoController controller, String? meetingLink) {
  if (!_shouldEnableJoinButton(controller, meetingLink)) {
    return "Register to Join Meeting";
  }

  final eventInfo = controller.state.eventInfo.value!;
  final organizerId = eventInfo.organizer.id;
  final isOrganizer =
      organizerId.isNotEmpty && controller.isOrganizer(organizerId);

  if (isOrganizer) {
    return meetingLink != null && meetingLink.isNotEmpty
        ? "You're the Organizer!"
        : "Your Event Link";
  }

  return meetingLink != null && meetingLink.isNotEmpty
      ? "Click to Join Meeting"
      : "Link Not Available Yet";
}
