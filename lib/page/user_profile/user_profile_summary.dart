import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfilebuildSummary() {
  final controller = Get.find<UserProfileController>();

  final extended = controller.state.userProfile.value?.extendedProfile;

  return Column(
    children: [
      userProfilebuildInfoRow(
        icon: Icons.description,
        label: 'short_bio'.tr,
        value: controller.bio.isEmpty ? "No bio added yet" : controller.bio,
        iconColor: Colors.blue,
        maxLines: 5,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.work_history,
        label: 'experience'.tr,
        value: extended?.yearsInBusiness != null
            ? "${extended!.yearsInBusiness}"
            : "not_specified".tr,
        iconColor: Colors.orange,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.video_call,
        label: 'available_for_1_on_1'.tr,
        value: extended?.availabilitySlots ?? "availability_not_set".tr,
        iconColor: Colors.green,
      ),
      if (extended != null && extended.knownLanguages.isNotEmpty) ...[
        SizedBox(height: 2.hp),
        opearingRegionBuildChipSection(
          icon: Icons.translate,
          iconColor: Colors.teal,
          label: 'known_languages'.tr,
          chips: extended.knownLanguages,
        ),
      ],
      if (extended != null && extended.skills.isNotEmpty) ...[
        SizedBox(height: 2.hp),
        opearingRegionBuildChipSection(
          icon: Icons.lightbulb_outline,
          iconColor: Colors.orange,
          label: 'skills'.tr,
          chips: extended.skills,
        ),
      ],
    ],
  );
}
