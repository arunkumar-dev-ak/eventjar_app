import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/page/bio_profile/schedule_meeting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class BioProfilePage extends GetView<BioProfileController> {
  const BioProfilePage({super.key});

  static const double _avatarRadius = 65;

  bool get _hasAboutOrNetworkingContent =>
      controller.bio.isNotEmpty ||
      controller.preferredLocations.isNotEmpty ||
      controller.interestedInConnecting.isNotEmpty ||
      controller.helpOfferings.isNotEmpty ||
      controller.discussionTopics.isNotEmpty;

  bool get _hasGalleryOrBadgesContent =>
      controller.galleryImages.isNotEmpty ||
      controller.badgeAssignments.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final barHeight = topPad + 36;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goBack();
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildGradientBar(barHeight, topPad),
            Expanded(child: Obx(() => _buildBody(context))),
          ],
        ),
        bottomNavigationBar: Obx(() {
          if (controller.state.isLoading.value ||
              controller.state.hasError.value ||
              controller.isOwnProfile) {
            return const SizedBox.shrink();
          }
          return _buildBottomBar(context);
        }),
      ),
    );
  }

  Widget _buildGradientBar(double barHeight, double topPad) {
    return Container(
      height: barHeight,
      padding: EdgeInsets.only(top: topPad),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientDarkStart,
            AppColors.gradientLightStart,
            AppColors.gradientLightEnd,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => controller.goBack(),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.state.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state.hasError.value) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.wp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.textSecondary(context),
              ),
              SizedBox(height: 2.hp),
              Text(
                controller.state.errorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(height: 2.hp),
              OutlinedButton(
                onPressed: controller.retry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final gradientBodyHeight = _avatarRadius * 1.2;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Avatar overlapping gradient → white
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Gradient + white background
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: gradientBodyHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientDarkStart,
                          AppColors.gradientLightStart,
                          AppColors.gradientLightEnd,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: _avatarRadius + 8,
                    color: AppColors.cardBg(context),
                  ),
                ],
              ),
              // Avatar centered at the boundary
              Positioned(
                top: gradientBodyHeight - _avatarRadius,
                child: _buildAvatar(),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            color: AppColors.cardBg(context),
            child: Column(
              children: [
                _buildNameSection(context),
                SizedBox(height: 1.5.hp),
                _buildBio(context),
                SizedBox(height: 2.hp),
                _buildDivider(context),
                SizedBox(height: 1.5.hp),
                _buildStatsRow(context),
                SizedBox(height: 1.5.hp),
                _buildDivider(context),
                SizedBox(height: 2.5.hp),
                _buildNetworkingGoal(context),
                _buildProfessionalSection(context),
                if (_hasAboutOrNetworkingContent) ...[
                  _buildDivider(context),
                  SizedBox(height: 2.5.hp),
                  _buildAboutSection(context),
                  SizedBox(height: 2.5.hp),
                  _buildOperatingLocationSection(context),
                  _buildNetworkingSection(context),
                ],
                if (_hasGalleryOrBadgesContent) ...[
                  _buildDivider(context),
                  SizedBox(height: 2.5.hp),
                  _buildGallerySection(context),
                  _buildBadgesSection(context),
                ],
                SizedBox(height: 4.hp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: controller.avatarUrl.isNotEmpty
          ? CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(getFileUrl(controller.avatarUrl)),
            )
          : CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: Colors.white,
              child: Text(
                _getInitials(controller.name),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ),
    );
  }

  Widget _buildNameSection(BuildContext context) {
    return Column(
      children: [
        Text(
          controller.name,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        if (controller.username.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '@${controller.username}',
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
        _buildSocialLinks(context),
      ],
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    final social = controller.socialLinks;
    if (social == null) return const SizedBox.shrink();

    final links = <_SocialItem>[
      if (social.linkedin != null && social.linkedin!.isNotEmpty)
        _SocialItem('linkedin', FontAwesomeIcons.linkedinIn, social.linkedin!),
      if (social.twitter != null && social.twitter!.isNotEmpty)
        _SocialItem('twitter', FontAwesomeIcons.xTwitter, social.twitter!),
      if (social.instagram != null && social.instagram!.isNotEmpty)
        _SocialItem('instagram', FontAwesomeIcons.instagram, social.instagram!),
      if (social.facebook != null && social.facebook!.isNotEmpty)
        _SocialItem('facebook', FontAwesomeIcons.facebookF, social.facebook!),
    ];

    if (links.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 1.hp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: links.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                final url = item.url.startsWith('http')
                    ? item.url
                    : 'https://${item.url}';
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _socialColor(item.platform).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  item.icon,
                  size: 18,
                  color: _socialColor(item.platform),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _socialColor(String platform) {
    switch (platform) {
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'twitter':
        return const Color(0xFF000000);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      default:
        return AppColors.gradientDarkStart;
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(5.wp, 1.2.hp, 5.wp, 1.2.hp + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () {
            if (!controller.isLoggedIn) {
              Get.toNamed(RouteName.signInPage);
              return;
            }
            ScheduleMeetingDialog.show(
              context,
              name: controller.name,
              position: controller.position,
              company: controller.businessName,
            );
          },
          icon: const Icon(Icons.calendar_month_outlined, size: 20),
          label: Text(
            'Schedule 1-on-1 Meeting',
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gradientDarkStart,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    if (controller.bio.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      context,
      icon: Icons.info_outline_rounded,
      title: 'ABOUT',
      child: Text(
        controller.bio,
        style: TextStyle(
          fontSize: 9.5.sp,
          color: AppColors.textSecondary(context),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    if (controller.shortBio.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.wp),
      child: Text(
        controller.shortBio,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9.5.sp,
          color: AppColors.textSecondary(context),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.event_available_rounded,
              count: controller.eventsCount.toString(),
              label: 'Attended Events',
              color: AppColors.gradientDarkStart,
            ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.people_outline_rounded,
              count: controller.contactsCount.toString(),
              label: 'Connections',
              color: AppColors.gradientLightEnd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.hp, horizontal: 3.wp),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          SizedBox(height: 0.8.hp),
          Text(
            count,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkingGoal(BuildContext context) {
    if (controller.networkingGoal.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(left: 5.wp, right: 5.wp, bottom: 2.5.hp),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.hp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientDarkStart.withValues(alpha: 0.08),
              AppColors.gradientLightEnd.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NETWORKING GOAL',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.gradientDarkStart,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 0.8.hp),
            Text(
              controller.networkingGoal,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalSection(BuildContext context) {
    if (controller.position.isEmpty &&
        controller.businessCategory.isEmpty &&
        controller.location.isEmpty &&
        controller.website.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      icon: Icons.work_outline_rounded,
      title: 'PROFESSIONAL',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoPair(
                  context,
                  label: 'Position',
                  value: controller.position.isNotEmpty
                      ? controller.position
                      : '-',
                ),
              ),
              Expanded(
                child: _buildInfoPair(
                  context,
                  label: 'Company',
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
                child: _buildInfoPair(
                  context,
                  label: 'Industry',
                  value: controller.businessCategory.isNotEmpty
                      ? controller.businessCategory
                      : '-',
                ),
              ),
              Expanded(
                child: _buildInfoPair(
                  context,
                  label: 'Location',
                  value: controller.location.isNotEmpty
                      ? controller.location
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
                child: _buildInfoPair(
                  context,
                  label: 'Experience',
                  value: controller.yearsInBusiness.isNotEmpty
                      ? controller.yearsInBusiness
                      : '-',
                ),
              ),
              Expanded(
                child: controller.website.isNotEmpty
                    ? _buildWebsitePair(context)
                    : _buildInfoPair(context, label: 'Website', value: '-'),
              ),
            ],
          ),
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
          'Website',
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

  Widget _buildOperatingLocationSection(BuildContext context) {
    if (controller.preferredLocations.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _buildSection(
          context,
          icon: Icons.location_on_outlined,
          title: 'OPERATING LOCATIONS',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.preferredLocations
                .map(
                  (location) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.wp,
                      vertical: 0.6.hp,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _buildDivider(context),
        SizedBox(height: 2.5.hp),
      ],
    );
  }

  Widget _buildNetworkingSection(BuildContext context) {
    if (controller.interestedInConnecting.isEmpty &&
        controller.helpOfferings.isEmpty &&
        controller.discussionTopics.isEmpty) {
      return const SizedBox.shrink();
    }
    return _buildSection(
      context,
      icon: Icons.people_outline_rounded,
      title: 'NETWORKING',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.interestedInConnecting.isNotEmpty) ...[
            _buildChipRow(
              context,
              icon: Icons.people_outline,
              label: 'Looking to connect with',
              items: controller.interestedInConnecting,
              color: AppColors.gradientDarkStart,
            ),
            SizedBox(height: 1.5.hp),
          ],
          if (controller.helpOfferings.isNotEmpty) ...[
            _buildChipRow(
              context,
              icon: Icons.verified_outlined,
              label: 'Can help with',
              items: controller.helpOfferings,
              color: Colors.green,
            ),
            SizedBox(height: 1.5.hp),
          ],
          if (controller.discussionTopics.isNotEmpty)
            _buildChipRow(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Open to discuss',
              items: controller.discussionTopics,
              color: Colors.deepPurple,
            ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    if (controller.galleryImages.isEmpty) return const SizedBox.shrink();
    final images = controller.galleryImages;
    return Column(
      children: [
        _buildSection(
          context,
          icon: Icons.photo_library_outlined,
          title: 'GALLERY (${images.length})',
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    height: 24.hp,
                    viewportFraction: 1,
                    enableInfiniteScroll: images.length > 1,
                    autoPlay: images.length > 1,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    onPageChanged: (index, _) {
                      controller.state.galleryIndex.value = index;
                    },
                  ),
                  itemBuilder: (context, index, _) {
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        RouteName.imageViewerPage,
                        arguments: {
                          "fileUrl": getFileUrl(images[index]),
                          "header": controller.name,
                        },
                      ),
                      child: CachedNetworkImage(
                        imageUrl: getFileUrl(images[index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (images.length > 1) ...[
                SizedBox(height: 1.2.hp),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      final isActive =
                          controller.state.galleryIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? AppColors.gradientDarkStart
                              : AppColors.gradientDarkStart.withValues(
                                  alpha: 0.25,
                                ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ],
          ),
        ),
        _buildDivider(context),
        SizedBox(height: 2.5.hp),
      ],
    );
  }

  Widget _buildBadgesSection(BuildContext context) {
    if (controller.badgeAssignments.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      context,
      icon: Icons.military_tech_outlined,
      title: 'BADGES (${controller.badgeAssignments.length})',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.badgeAssignments
            .where((b) => b.customBadge?.name != null)
            .map(
              (b) => _buildBadgeItem(
                context,
                label: b.customBadge!.name!,
                color: b.customBadge?.color,
                imageUrl: b.customBadge?.imageUrl?.toString(),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Reusable ──

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.gradientDarkStart),
              SizedBox(width: 2.wp),
              Text(
                title,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gradientDarkStart,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.hp),
          child,
          SizedBox(height: 2.hp),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 5.wp,
      endIndent: 5.wp,
      color: AppColors.divider(context),
    );
  }

  Widget _buildInfoPair(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildChipRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required List<String> items,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.wp,
                    vertical: 0.6.hp,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(
    BuildContext context, {
    required String label,
    String? color,
    String? imageUrl,
  }) {
    final badgeColor = color != null && color.isNotEmpty
        ? Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16))
        : AppColors.gradientDarkStart;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    return Container(
      width: 110,
      padding: EdgeInsets.symmetric(vertical: 1.5.hp, horizontal: 2.wp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        children: [
          if (hasImage)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: getFileUrl(imageUrl),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.military_tech_outlined,
                    color: badgeColor,
                    size: 22,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
              ),
              child: Icon(
                Icons.military_tech_outlined,
                color: badgeColor,
                size: 22,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _SocialItem {
  final String platform;
  final IconData icon;
  final String url;

  _SocialItem(this.platform, this.icon, this.url);
}
