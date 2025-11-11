import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Widget userProfileBuildSocialLinks() {
  final controller = Get.find<UserProfileController>();

  final socialLinks = controller.socialLinks;

  return Column(
    children: [
      _buildSocialLinkRow(
        icon: Icons.link,
        platform: "LinkedIn",
        url: socialLinks['linkedin']!.isEmpty
            ? "Not connected"
            : socialLinks['linkedin']!,
        color: Colors.blue.shade700,
        isConnected: socialLinks['linkedin']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      _buildSocialLinkRow(
        icon: Icons.camera_alt,
        platform: "Instagram",
        url: socialLinks['instagram']!.isEmpty
            ? "Not connected"
            : socialLinks['instagram']!,
        color: Colors.pink.shade400,
        isConnected: socialLinks['instagram']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      _buildSocialLinkRow(
        icon: Icons.facebook,
        platform: "Facebook",
        url: socialLinks['facebook']!.isEmpty
            ? "Not connected"
            : socialLinks['facebook']!,
        color: Colors.blue.shade600,
        isConnected: socialLinks['facebook']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      _buildSocialLinkRow(
        icon: Icons.alternate_email,
        platform: "Twitter",
        url: socialLinks['twitter']!.isEmpty
            ? "Not connected"
            : socialLinks['twitter']!,
        color: Colors.lightBlue.shade400,
        isConnected: socialLinks['twitter']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      _buildSocialLinkRow(
        icon: Icons.language,
        platform: "Website",
        url: socialLinks['website']!.isEmpty
            ? "Not provided"
            : socialLinks['website']!,
        color: Colors.green.shade600,
        isConnected: socialLinks['website']!.isNotEmpty,
      ),
    ],
  );
}

Widget _buildSocialLinkRow({
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
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isConnected ? color : Colors.grey.shade500,
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
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.3.hp),
            Text(
              url,
              style: TextStyle(
                fontSize: 10.sp,
                color: isConnected ? color : Colors.grey.shade500,
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
          color: isConnected ? color : Colors.grey.shade400,
        ),
      ),
    ],
  );
}
