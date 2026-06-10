import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BioProfileNetworkingGoal extends GetView<BioProfileController> {
  const BioProfileNetworkingGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientDarkStart.withValues(alpha: 0.06),
              AppColors.gradientLightEnd.withValues(alpha: 0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.track_changes_rounded,
                size: 20,
                color: AppColors.gradientDarkStart,
              ),
            ),
            SizedBox(width: 3.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'networking_goal'.tr,
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gradientDarkStart,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.networkingGoal,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BioProfileProfessionalCard extends GetView<BioProfileController> {
  const BioProfileProfessionalCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.position.isEmpty &&
        controller.businessCategory.isEmpty &&
        controller.location.isEmpty &&
        controller.website.isEmpty) {
      return const SizedBox.shrink();
    }

    return BioProfileCard(
      icon: Icons.work_outline_rounded,
      title: 'professional'.tr,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BioProfileInfoPair(
                  label: 'position'.tr,
                  value: controller.position.isNotEmpty
                      ? controller.position
                      : '-',
                ),
              ),
              Expanded(
                child: BioProfileInfoPair(
                  label: 'company'.tr,
                  value: controller.businessName.isNotEmpty
                      ? controller.businessName
                      : '-',
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.hp),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BioProfileInfoPair(
                  label: 'industry'.tr,
                  value: controller.businessCategory.isNotEmpty
                      ? controller.businessCategory
                      : '-',
                ),
              ),
              Expanded(
                child: BioProfileInfoPair(
                  label: 'experience'.tr,
                  value: controller.yearsInBusiness.isNotEmpty
                      ? controller.yearsInBusiness
                      : '-',
                ),
              ),
            ],
          ),
          if (controller.location.isNotEmpty ||
              controller.website.isNotEmpty) ...[
            SizedBox(height: 1.5.hp),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: controller.location.isNotEmpty
                      ? BioProfileInfoPair(
                          label: 'location'.tr,
                          value: controller.location,
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: controller.website.isNotEmpty
                      ? _buildWebsitePair(context)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWebsitePair(BuildContext context) {
    final url = controller.website.startsWith('http')
        ? controller.website
        : 'https://${controller.website}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'website'.tr,
          style: TextStyle(
            fontSize: 8.sp,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () =>
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          child: Text(
            controller.website,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.gradientDarkStart,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.gradientDarkStart,
            ),
          ),
        ),
      ],
    );
  }
}

class BioProfileAboutCard extends GetView<BioProfileController> {
  const BioProfileAboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BioProfileCard(
      icon: Icons.info_outline_rounded,
      title: 'about'.tr,
      child: Text(
        controller.bio,
        style: TextStyle(
          fontSize: 9.5.sp,
          color: AppColors.textSecondary(context),
          height: 1.7,
        ),
      ),
    );
  }
}

class BioProfileOperatingLocationCard extends GetView<BioProfileController> {
  const BioProfileOperatingLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BioProfileCard(
      icon: Icons.location_on_outlined,
      title: 'operating_locations'.tr,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.preferredLocations
            .map(
              (location) => BioProfileModernChip(
                label: location,
                icon: Icons.location_on,
                color: const Color(0xFF2196F3),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BioProfileLanguagesCard extends GetView<BioProfileController> {
  const BioProfileLanguagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BioProfileCard(
      icon: Icons.translate_rounded,
      title: 'known_languages'.tr,
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: controller.knownLanguages
            .map(
              (lang) => BioProfileModernChip(
                label: lang,
                icon: Icons.language_rounded,
                color: Colors.teal,
              ),
            )
            .toList(),
      ),
    );
  }
}

class BioProfileSkillsCard extends GetView<BioProfileController> {
  const BioProfileSkillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BioProfileCard(
      icon: Icons.lightbulb_outline_rounded,
      title: 'skills'.tr,
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: controller.skills
            .map(
              (skill) => BioProfileModernChip(
                label: skill,
                icon: Icons.auto_awesome,
                color: const Color(0xFFFF9800),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BioProfileNetworkingCard extends GetView<BioProfileController> {
  const BioProfileNetworkingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BioProfileCard(
      icon: Icons.people_outline_rounded,
      title: 'networking'.tr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.interestedInConnecting.isNotEmpty) ...[
            BioProfileChipGroup(
              icon: Icons.people_outline,
              label: 'looking_to_connect_with'.tr,
              items: controller.interestedInConnecting,
              color: AppColors.gradientDarkStart,
            ),
            SizedBox(height: 2.hp),
          ],
          if (controller.helpOfferings.isNotEmpty) ...[
            BioProfileChipGroup(
              icon: Icons.verified_outlined,
              label: 'can_help_with'.tr,
              items: controller.helpOfferings,
              color: const Color(0xFF4CAF50),
            ),
            SizedBox(height: 2.hp),
          ],
          if (controller.discussionTopics.isNotEmpty)
            BioProfileChipGroup(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'open_to_discuss'.tr,
              items: controller.discussionTopics,
              color: const Color(0xFF673AB7),
            ),
        ],
      ),
    );
  }
}
