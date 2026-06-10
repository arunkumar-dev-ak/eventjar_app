import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_badges.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_bottom_bar.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_content_cards.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_gallery.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_header.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_stats.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioProfilePage extends GetView<BioProfileController> {
  const BioProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg(context),
        body: Obx(() => _buildBody(context)),
        bottomNavigationBar: Obx(() {
          if (controller.state.isLoading.value ||
              controller.state.hasError.value ||
              controller.isOwnProfile) {
            return const SizedBox.shrink();
          }
          return const BioProfileBottomBar();
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.state.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state.hasError.value) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.wp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                ),
                SizedBox(height: 2.5.hp),
                Text(
                  controller.state.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary(context),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 2.5.hp),
                FilledButton.icon(
                  onPressed: controller.retry,
                  icon: Icon(Icons.refresh_rounded, size: 18),
                  label: Text('try_again'.tr),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gradientDarkStart,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const BioProfileSliverHeader(),
        SliverToBoxAdapter(child: _buildProfileContent(context)),
      ],
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: BioProfileSliverHeader.avatarRadius - 30),
        const BioProfileNameSection(),
        SizedBox(height: 2.hp),
        const BioProfileStatsRow(),
        SizedBox(height: 2.hp),
        if (controller.networkingGoal.isNotEmpty) ...[
          const BioProfileNetworkingGoal(),
          SizedBox(height: 2.hp),
        ],
        const BioProfileProfessionalCard(),
        if (controller.hasAboutOrNetworkingContent) ...[
          if (controller.bio.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileAboutCard(),
          ],
          if (controller.preferredLocations.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileOperatingLocationCard(),
          ],
          if (controller.knownLanguages.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileLanguagesCard(),
          ],
          if (controller.skills.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileSkillsCard(),
          ],
          if (controller.interestedInConnecting.isNotEmpty ||
              controller.helpOfferings.isNotEmpty ||
              controller.discussionTopics.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileNetworkingCard(),
          ],
        ],
        if (controller.hasGalleryOrBadgesContent) ...[
          if (controller.galleryImages.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileGalleryCard(),
          ],
          if (controller.badgeAssignments.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            const BioProfileBadgesCard(),
          ],
        ],
        SizedBox(height: 4.hp),
      ],
    );
  }
}
