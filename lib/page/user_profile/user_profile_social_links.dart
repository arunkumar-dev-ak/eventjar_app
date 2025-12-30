import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Widget userProfileBuildSocialLinks() {
  final controller = Get.find<UserProfileController>();
  final socialLinks = controller.socialLinks;

  final links = [
    _SocialLinkData(
      icon: Icons.link_rounded,
      platform: "LinkedIn",
      url: socialLinks['linkedin'] ?? '',
      color: const Color(0xFF0A66C2),
    ),
    _SocialLinkData(
      icon: Icons.camera_alt_rounded,
      platform: "Instagram",
      url: socialLinks['instagram'] ?? '',
      gradientColors: [
        const Color(0xFFF58529),
        const Color(0xFFDD2A7B),
        const Color(0xFF8134AF),
      ],
    ),
    _SocialLinkData(
      icon: Icons.facebook_rounded,
      platform: "Facebook",
      url: socialLinks['facebook'] ?? '',
      color: const Color(0xFF1877F2),
    ),
    _SocialLinkData(
      icon: Icons.alternate_email_rounded,
      platform: "Twitter / X",
      url: socialLinks['twitter'] ?? '',
      color: Colors.black87,
    ),
    _SocialLinkData(
      icon: Icons.language_rounded,
      platform: "Website",
      url: socialLinks['website'] ?? '',
      color: Colors.teal,
    ),
  ];

  // Separate connected and not connected
  final connectedLinks = links.where((l) => l.url.isNotEmpty).toList();
  final notConnectedLinks = links.where((l) => l.url.isEmpty).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Connected links as cards
      if (connectedLinks.isNotEmpty) ...[
        Wrap(
          spacing: 3.wp,
          runSpacing: 1.2.hp,
          children: connectedLinks
              .map((link) => _buildSocialCard(link))
              .toList(),
        ),
        if (notConnectedLinks.isNotEmpty) SizedBox(height: 2.5.hp),
      ],

      // Not connected - show as small chips
      if (notConnectedLinks.isNotEmpty) ...[
        Text(
          'Not Connected',
          style: TextStyle(
            fontSize: 7.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.2.hp),
        Wrap(
          spacing: 2.5.wp,
          runSpacing: 1.hp,
          children: notConnectedLinks
              .map((link) => _buildNotConnectedChip(link))
              .toList(),
        ),
      ],
      SizedBox(height: 2.hp),
      // If nothing is connected
      if (connectedLinks.isEmpty &&
          notConnectedLinks.length == links.length) ...[
        Container(
          padding: EdgeInsets.all(4.wp),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.link_off_rounded,
                size: 20,
                color: Colors.grey.shade400,
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Text(
                  'Connect your social accounts to grow your network',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ],
  );
}

Widget _buildSocialCard(_SocialLinkData link) {
  return GestureDetector(
    onTap: () => _launchUrl(link.url),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.2.hp),
      decoration: BoxDecoration(
        gradient: link.gradientColors != null
            ? LinearGradient(colors: link.gradientColors!)
            : LinearGradient(
                colors: [
                  link.color!.withValues(alpha: 0.9),
                  link.color!.withValues(alpha: 0.7),
                ],
              ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (link.color ?? link.gradientColors!.first).withValues(
              alpha: 0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(link.icon, size: 16, color: Colors.white),
          SizedBox(width: 2.wp),
          Text(
            link.platform,
            style: TextStyle(
              fontSize: 8.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 1.5.wp),
          Icon(
            Icons.open_in_new_rounded,
            size: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNotConnectedChip(_SocialLinkData link) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(link.icon, size: 14, color: Colors.grey.shade400),
        SizedBox(width: 1.5.wp),
        Text(
          link.platform,
          style: TextStyle(fontSize: 7.sp, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}

Future<void> _launchUrl(String url) async {
  try {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      AppSnackbar.warning(
        title: "Unable to Open Link",
        message: "Could not launch $url",
      );
    }
  } catch (e) {
    AppSnackbar.error(title: "Error", message: "Invalid URL");
  }
}

class _SocialLinkData {
  final IconData icon;
  final String platform;
  final String url;
  final Color? color;
  final List<Color>? gradientColors;

  _SocialLinkData({
    required this.icon,
    required this.platform,
    required this.url,
    this.color,
    this.gradientColors,
  });
}
