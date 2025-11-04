import 'package:eventjar_app/controller/user_profile/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildLocationInfo() {
  final controller = Get.find<UserProfileController>();

  final profile = controller.state.userProfile.value;
  final extended = profile?.extendedProfile;

  return Column(
    children: [
      userProfilebuildInfoRow(
        icon: Icons.location_on,
        label: "Location",
        value: profile?.location ?? "Not provided",
        iconColor: Colors.red,
      ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.preferredLocations.isNotEmpty)
        userProfileBuildChipSection(
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
