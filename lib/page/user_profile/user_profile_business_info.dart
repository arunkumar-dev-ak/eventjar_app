import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_social_links.dart';
import 'package:eventjar/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildBusinessInfo() {
  final controller = Get.find<UserProfileController>();

  final user = controller.state.userProfile.value;
  final extended = user?.extendedProfile;
  final socialLinks = controller.socialLinks;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      userProfilebuildInfoRow(
        icon: Icons.business,
        label: 'business_name'.tr,
        value: user?.company ?? 'not_provided'.tr,
        iconColor: Colors.purple,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.category,
        label: 'business_category'.tr,
        value: extended?.businessCategory ?? 'not_specified'.tr,
        iconColor: Colors.teal,
      ),
      SizedBox(height: 2.hp),
      buildSocialLinkRow(
        icon: Icons.language,
        platform: 'website'.tr,
        url: socialLinks['website']!.isEmpty
            ? 'not_provided'.tr
            : socialLinks['website']!,
        color: Colors.green.shade600,
        isConnected: socialLinks['website']!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.email_outlined,
        label: 'business_email'.tr,
        value: extended?.businessEmail ?? 'not_provided'.tr,
        iconColor: Colors.red,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.phone_in_talk,
        label: 'business_phone'.tr,
        value: extended?.businessPhoneParsed?.fullNumber ?? 'not_provided'.tr,
        iconColor: Colors.green,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.location_city,
        label: 'business_address'.tr,
        value: user?.location ?? 'not_provided'.tr,
        iconColor: Colors.orange,
      ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.preferredLocations.isNotEmpty)
        opearingRegionBuildChipSection(
          icon: Icons.public,
          iconColor: Colors.blue,
          label: 'operating_regions'.tr,
          chips: extended.preferredLocations,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.public,
          label: 'operating_regions'.tr,
          value: 'not_specified'.tr,
          iconColor: Colors.blue,
        ),
    ],
  );
}
