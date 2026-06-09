import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildNetworkInfo() {
  final controller = Get.find<UserProfileController>();

  final extended = controller.state.userProfile.value?.extendedProfile;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      userProfilebuildInfoRow(
        icon: Icons.search,
        label: 'what_are_you_looking_for'.tr,
        value: extended?.networkingGoal ?? 'not_specified'.tr,
        iconColor: Colors.purple,
        maxLines: 3,
      ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.interestedInConnecting.isNotEmpty)
        userProfileBuildChipSection(
          label: 'interested_in_connecting_with'.tr,
          chips: extended.interestedInConnecting,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.group_add,
          label: 'interested_in_connecting_with'.tr,
          value: 'not_specified'.tr,
          iconColor: Colors.blue,
        ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.helpOfferings.isNotEmpty)
        userProfileBuildChipSection(
          label: 'how_help_others'.tr,
          chips: extended.helpOfferings,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.help_outline,
          label: 'how_help_others'.tr,
          value: 'not_specified'.tr,
          iconColor: Colors.green,
        ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.discussionTopics.isNotEmpty)
        userProfileBuildChipSection(
          label: 'topics_open_to_discussing'.tr,
          chips: extended.discussionTopics,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.chat_bubble_outline,
          label: 'topics_open_to_discussing'.tr,
          value: 'not_specified'.tr,
          iconColor: Colors.orange,
        ),
    ],
  );
}
