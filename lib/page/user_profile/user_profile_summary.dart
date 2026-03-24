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
        label: "Short Bio",
        value: controller.bio.isEmpty ? "No bio added yet" : controller.bio,
        iconColor: Colors.blue,
        maxLines: 5,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.work_history,
        label: "Experience",
        value: extended?.yearsInBusiness != null
            ? "${extended!.yearsInBusiness}"
            : "Not specified",
        iconColor: Colors.orange,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.video_call,
        label: "Available for 1-on-1 Meeting",
        value: extended?.availabilitySlots ?? "Availability not set",
        iconColor: Colors.green,
      ),
    ],
  );
}
