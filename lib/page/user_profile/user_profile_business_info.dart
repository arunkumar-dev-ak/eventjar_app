import 'package:eventjar_app/controller/user_profile/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildBusinessInfo() {
  final controller = Get.find<UserProfileController>();

  final extended = controller.state.userProfile.value?.extendedProfile;

  return Column(
    children: [
      userProfilebuildInfoRow(
        icon: Icons.business,
        label: "Business Name",
        value: extended?.businessName ?? "Not provided",
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
        value: extended?.businessWebsite ?? "Not provided",
        iconColor: Colors.blue,
        isLink:
            extended?.businessWebsite != null &&
            extended!.businessWebsite!.isNotEmpty,
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
        value: extended?.businessAddress ?? "Not provided",
        iconColor: Colors.orange,
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.calendar_today,
        label: "Years in Business",
        value: extended?.yearsInBusiness != null
            ? "${extended!.yearsInBusiness} Years"
            : "Not specified",
        iconColor: Colors.indigo,
      ),
    ],
  );
}
