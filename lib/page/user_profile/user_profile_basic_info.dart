import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildBasicInfo() {
  final controller = Get.find<UserProfileController>();

  return Column(
    children: [
      // userProfilebuildInfoRow(
      //   icon: Icons.person,
      //   label: "Username",
      //   value: controller.username.isEmpty ? "N/A" : controller.username,
      //   iconColor: Colors.blue,
      // ),
      // SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.email,
        label: "Email Address",
        value: controller.email.isEmpty ? "N/A" : controller.email,
        iconColor: Colors.red,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.phone,
        label: "Mobile Number",
        value: controller.phone.isEmpty ? "Not provided" : controller.phone,
        iconColor: Colors.green,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.work,
        label: "Professional Title",
        value: controller.professionalTitle.isEmpty
            ? "Not specified"
            : controller.professionalTitle,
        iconColor: Colors.orange,
      ),
    ],
  );
}
