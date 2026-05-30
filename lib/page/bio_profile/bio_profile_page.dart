import 'package:cached_network_image/cached_network_image.dart';
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

  static const double _avatarRadius = 60;

  bool get _hasAboutOrNetworkingContent =>
      controller.bio.isNotEmpty ||
      controller.preferredLocations.isNotEmpty ||
      controller.interestedInConnecting.isNotEmpty ||
      controller.helpOfferings.isNotEmpty ||
      controller.discussionTopics.isNotEmpty ||
      controller.knownLanguages.isNotEmpty ||
      controller.skills.isNotEmpty;

  bool get _hasGalleryOrBadgesContent =>
      controller.galleryImages.isNotEmpty ||
      controller.badgeAssignments.isNotEmpty;

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
          return _buildBottomBar(context);
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
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try Again'),
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
        _buildSliverHeader(context),
        SliverToBoxAdapter(child: _buildProfileContent(context)),
      ],
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 16.hp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkStart,
                  AppColors.gradientDarkStart.withValues(alpha: 0.85),
                  AppColors.gradientLightEnd.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: topPad),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  onPressed: () => controller.goBack(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.hp - _avatarRadius - 6,
            left: 0,
            right: 0,
            child: Center(child: _buildAvatar(context)),
          ),
          Positioned(
            right: 3.wp,
            top: topPad + 8,
            child: _buildSocialLinksVertical(context),
          ),
          SizedBox(height: 16.hp + _avatarRadius - 6),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: _avatarRadius - 30),
        _buildNameSection(context),
        SizedBox(height: 2.hp),
        _buildStatsRow(context),
        SizedBox(height: 2.hp),
        if (controller.networkingGoal.isNotEmpty) ...[
          _buildNetworkingGoal(context),
          SizedBox(height: 2.hp),
        ],
        _buildProfessionalCard(context),
        if (_hasAboutOrNetworkingContent) ...[
          if (controller.bio.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildAboutCard(context),
          ],
          if (controller.preferredLocations.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildOperatingLocationCard(context),
          ],
          if (controller.knownLanguages.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildLanguagesCard(context),
          ],
          if (controller.skills.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildSkillsCard(context),
          ],
          if (controller.interestedInConnecting.isNotEmpty ||
              controller.helpOfferings.isNotEmpty ||
              controller.discussionTopics.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildNetworkingCard(context),
          ],
        ],
        if (_hasGalleryOrBadgesContent) ...[
          if (controller.galleryImages.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildGalleryCard(context),
          ],
          if (controller.badgeAssignments.isNotEmpty) ...[
            SizedBox(height: 2.hp),
            _buildBadgesCard(context),
          ],
        ],
        SizedBox(height: 4.hp),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cardBg(context), width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: controller.avatarUrl.isNotEmpty
          ? CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: AppColors.cardBg(context),
              backgroundImage: NetworkImage(getFileUrl(controller.avatarUrl)),
            )
          : CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: AppColors.gradientDarkStart.withValues(
                alpha: 0.1,
              ),
              child: Text(
                _getInitials(controller.name),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ),
    );
  }

  Widget _buildNameSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp),
      child: Column(
        children: [
          Text(
            controller.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
              letterSpacing: -0.3,
            ),
          ),
          if (controller.username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gradientDarkStart.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '@${controller.username}',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ),
          ],
          if (controller.shortBio.isNotEmpty) ...[
            SizedBox(height: 1.hp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.wp),
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
            ),
          ],
        ],
      ),
    );
  }

  List<_SocialItem> _getSocialLinks() {
    final social = controller.socialLinks;
    if (social == null) return [];
    return [
      if (social.linkedin != null && social.linkedin!.isNotEmpty)
        _SocialItem('linkedin', FontAwesomeIcons.linkedinIn, social.linkedin!),
      if (social.twitter != null && social.twitter!.isNotEmpty)
        _SocialItem('twitter', FontAwesomeIcons.xTwitter, social.twitter!),
      if (social.instagram != null && social.instagram!.isNotEmpty)
        _SocialItem('instagram', FontAwesomeIcons.instagram, social.instagram!),
      if (social.facebook != null && social.facebook!.isNotEmpty)
        _SocialItem('facebook', FontAwesomeIcons.facebookF, social.facebook!),
    ];
  }

  Widget _buildSocialLinksVertical(BuildContext context) {
    final links = _getSocialLinks();
    if (links.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: links.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              onTap: () {
                final url = item.url.startsWith('http')
                    ? item.url
                    : 'https://${item.url}';
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    item.icon,
                    size: 14,
                    color: _socialColor(item.platform, context),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _socialColor(String platform, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (platform) {
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'twitter':
        return isDark ? Colors.white : const Color(0xFF000000);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      default:
        return AppColors.gradientDarkStart;
    }
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
              label: 'Events',
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
      padding: EdgeInsets.symmetric(vertical: 2.hp, horizontal: 4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(context),
                  ),
                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkingGoal(BuildContext context) {
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
                    'Networking Goal',
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

  Widget _buildProfessionalCard(BuildContext context) {
    if (controller.position.isEmpty &&
        controller.businessCategory.isEmpty &&
        controller.location.isEmpty &&
        controller.website.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      context,
      icon: Icons.work_outline_rounded,
      title: 'Professional',
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
                  label: 'Experience',
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
                      ? _buildInfoPair(
                          context,
                          label: 'Location',
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

  Widget _buildAboutCard(BuildContext context) {
    return _buildCard(
      context,
      icon: Icons.info_outline_rounded,
      title: 'About',
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

  Widget _buildOperatingLocationCard(BuildContext context) {
    return _buildCard(
      context,
      icon: Icons.location_on_outlined,
      title: 'Operating Locations',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.preferredLocations
            .map(
              (location) => _buildModernChip(
                context,
                label: location,
                icon: Icons.location_on,
                color: const Color(0xFF2196F3),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLanguagesCard(BuildContext context) {
    return _buildCard(
      context,
      icon: Icons.translate_rounded,
      title: 'Known Languages',
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: controller.knownLanguages
            .map(
              (lang) => _buildModernChip(
                context,
                label: lang,
                icon: Icons.language_rounded,
                color: Colors.teal,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSkillsCard(BuildContext context) {
    return _buildCard(
      context,
      icon: Icons.lightbulb_outline_rounded,
      title: 'Skills',
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: controller.skills
            .map(
              (skill) => _buildModernChip(
                context,
                label: skill,
                icon: Icons.auto_awesome,
                color: const Color(0xFFFF9800),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildNetworkingCard(BuildContext context) {
    return _buildCard(
      context,
      icon: Icons.people_outline_rounded,
      title: 'Networking',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.interestedInConnecting.isNotEmpty) ...[
            _buildChipGroup(
              context,
              icon: Icons.people_outline,
              label: 'Looking to connect with',
              items: controller.interestedInConnecting,
              color: AppColors.gradientDarkStart,
            ),
            SizedBox(height: 2.hp),
          ],
          if (controller.helpOfferings.isNotEmpty) ...[
            _buildChipGroup(
              context,
              icon: Icons.verified_outlined,
              label: 'Can help with',
              items: controller.helpOfferings,
              color: const Color(0xFF4CAF50),
            ),
            SizedBox(height: 2.hp),
          ],
          if (controller.discussionTopics.isNotEmpty)
            _buildChipGroup(
              context,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Open to discuss',
              items: controller.discussionTopics,
              color: const Color(0xFF673AB7),
            ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context) {
    final images = controller.galleryImages;
    const int columns = 3;
    const int perPage = 6;
    const double spacing = 8;
    final int pageCount = (images.length / perPage).ceil();

    return _buildCard(
      context,
      icon: Icons.photo_library_outlined,
      title: 'Gallery',
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${images.length}',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.gradientDarkStart,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileSize =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final maxRows = (images.length > perPage ? perPage : images.length);
          final rows = (maxRows / columns).ceil();
          final gridHeight = rows * tileSize + (rows - 1) * spacing;

          return Column(
            children: [
              SizedBox(
                height: gridHeight,
                child: PageView.builder(
                  itemCount: pageCount,
                  onPageChanged: (index) {
                    controller.state.galleryIndex.value = index;
                  },
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * perPage;
                    final end = (start + perPage) > images.length
                        ? images.length
                        : start + perPage;
                    final pageImages = images.sublist(start, end);

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            childAspectRatio: 1,
                          ),
                      itemCount: pageImages.length,
                      itemBuilder: (context, index) {
                        final imgIndex = start + index;
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            RouteName.imageViewerPage,
                            arguments: {
                              "fileUrl": getFileUrl(images[imgIndex]),
                              "header": controller.name,
                            },
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: getFileUrl(images[imgIndex]),
                              fit: BoxFit.cover,
                              width: tileSize,
                              height: tileSize,
                              placeholder: (context, url) => Container(
                                color: AppColors.chipBg(context),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.chipBg(context),
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 28,
                                  color: AppColors.iconMuted(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 1.hp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: AppColors.textHint(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tap image to view full screen',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.textHint(context),
                    ),
                  ),
                ],
              ),
              if (pageCount > 1) ...[
                SizedBox(height: 1.5.hp),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageCount, (index) {
                      final isActive =
                          controller.state.galleryIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? AppColors.gradientDarkStart
                              : AppColors.gradientDarkStart.withValues(
                                  alpha: 0.2,
                                ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadgesCard(BuildContext context) {
    return _buildCard(
      context,
      icon: Icons.military_tech_outlined,
      title: 'Badges',
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${controller.badgeAssignments.length}',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.gradientDarkStart,
          ),
        ),
      ),
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

  Widget _buildBottomBar(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(5.wp, 1.2.hp, 5.wp, 1.2.hp + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        border: Border(
          top: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
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
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable Components ──

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border(context).withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow(context),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gradientDarkStart.withValues(alpha: 0.12),
                        AppColors.gradientLightEnd.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: AppColors.gradientDarkStart,
                  ),
                ),
                SizedBox(width: 2.5.wp),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            SizedBox(height: 2.hp),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildModernChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipGroup(
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.hp),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.5.wp,
                    vertical: 0.7.hp,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
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
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 1.5.hp, horizontal: 2.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
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
                    color: badgeColor.withValues(alpha: 0.1),
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
                    color: badgeColor.withValues(alpha: 0.1),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeColor.withValues(alpha: 0.1),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.sp,
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
  final FaIconData icon;
  final String url;

  _SocialItem(this.platform, this.icon, this.url);
}
