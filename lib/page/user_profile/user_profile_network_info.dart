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
        label: "What are you looking for?",
        value: extended?.networkingGoal ?? "Not specified",
        iconColor: Colors.purple,
        maxLines: 3,
      ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.interestedInConnecting.isNotEmpty)
        userProfileBuildChipSection(
          label: "Interested in Connecting With",
          chips: extended.interestedInConnecting,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.group_add,
          label: "Interested in Connecting With",
          value: "Not specified",
          iconColor: Colors.blue,
        ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.helpOfferings.isNotEmpty)
        userProfileBuildChipSection(
          label: "How can you help others?",
          chips: extended.helpOfferings,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.help_outline,
          label: "How can you help others?",
          value: "Not specified",
          iconColor: Colors.green,
        ),
      SizedBox(height: 2.hp),
      if (extended != null && extended.discussionTopics.isNotEmpty)
        userProfileBuildChipSection(
          label: "Topics you're open to discussing",
          chips: extended.discussionTopics,
        )
      else
        userProfilebuildInfoRow(
          icon: Icons.chat_bubble_outline,
          label: "Topics you're open to discussing",
          value: "Not specified",
          iconColor: Colors.orange,
        ),
    ],
  );
}
