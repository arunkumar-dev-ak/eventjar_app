import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildBusinessInfo() {
  final controller = Get.find<UserProfileController>();

  final user = controller.state.userProfile.value;
  final extended = user?.extendedProfile;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      userProfilebuildInfoRow(
        icon: Icons.business,
        label: "Business Name",
        value: user?.company ?? "Not provided",
        iconColor: Colors.purple,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.category,
        label: "Business Category",
        value: extended?.businessCategory ?? "Not specified",
        iconColor: Colors.teal,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.language,
        label: "Business Website",
        value: user?.website ?? "Not provided",
        iconColor: Colors.blue,
        isLink: user?.website != null && user!.website!.isNotEmpty,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.email_outlined,
        label: "Business Email",
        value: extended?.businessEmail ?? "Not provided",
        iconColor: Colors.red,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.phone_in_talk,
        label: "Business Phone",
        value: extended?.businessPhone ?? "Not provided",
        iconColor: Colors.green,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.location_city,
        label: "Business Address",
        value: user?.location ?? "Not provided",
        iconColor: Colors.orange,
      ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.preferredLocations.isNotEmpty)
        opearingRegionBuildChipSection(
          icon: Icons.public,
          iconColor: Colors.blue,
          label: "Operating Regions",
          chips: extended.preferredLocations,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.public,
          label: "Operating Regions",
          value: "Not specified",
          iconColor: Colors.blue,
        ),
    ],
  );
}
