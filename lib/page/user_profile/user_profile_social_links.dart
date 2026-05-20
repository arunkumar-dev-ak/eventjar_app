import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Widget userProfileBuildSocialLinks() {
  final controller = Get.find<UserProfileController>();

  final socialLinks = controller.socialLinks;

  return Column(
    children: [
      buildSocialLinkRow(
        icon: FontAwesomeIcons.linkedinIn,
        platform: "LinkedIn",
        url: socialLinks['linkedin']!.isEmpty
            ? "Not connected"
            : socialLinks['linkedin']!,
        color: const Color(0xFF0A66C2),
        isConnected: socialLinks['linkedin']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      buildSocialLinkRow(
        icon: FontAwesomeIcons.instagram,
        platform: "Instagram",
        url: socialLinks['instagram']!.isEmpty
            ? "Not connected"
            : socialLinks['instagram']!,
        color: const Color(0xFFE4405F),
        isConnected: socialLinks['instagram']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      buildSocialLinkRow(
        icon: FontAwesomeIcons.facebookF,
        platform: "Facebook",
        url: socialLinks['facebook']!.isEmpty
            ? "Not connected"
            : socialLinks['facebook']!,
        color: const Color(0xFF1877F2),
        isConnected: socialLinks['facebook']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      buildSocialLinkRow(
        icon: FontAwesomeIcons.xTwitter,
        platform: "X (Twitter)",
        url: socialLinks['twitter']!.isEmpty
            ? "Not connected"
            : socialLinks['twitter']!,
        color: const Color(0xFF000000),
        isConnected: socialLinks['twitter']!.isNotEmpty,
      ),
    ],
  );
}

Widget buildSocialLinkRow({
  required IconData icon,
  required String platform,
  required String url,
  required Color color,
  bool isConnected = true,
}) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          color: isConnected
              ? color.withValues(alpha: 0.1)
              : AppColors.greyBgStatic,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(
          icon,
          size: 18,
          color: isConnected ? color : AppColors.iconMutedStatic,
        ),
      ),
      SizedBox(width: 3.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              platform,
              style: TextStyle(
                fontSize: 8.sp,
                color: AppColors.textSecondaryStatic,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.3.hp),
            Text(
              url,
              style: TextStyle(
                fontSize: 10.sp,
                color: isConnected ? color : AppColors.textHintStatic,
                fontWeight: isConnected ? FontWeight.w600 : FontWeight.normal,
                decoration: isConnected ? TextDecoration.underline : null,
                fontStyle: isConnected ? null : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: isConnected
            ? () async {
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                } else {
                  AppSnackbar.warning(
                    title: "Unable to Open Link",
                    message: "Could not launch $url",
                  );
                }
              }
            : null,
        child: Icon(
          isConnected ? Icons.open_in_new : Icons.link_off,
          size: 16,
          color: isConnected ? color : AppColors.iconMutedStatic,
        ),
      ),
    ],
  );
}
