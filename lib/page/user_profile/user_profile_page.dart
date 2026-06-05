import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/theme_store.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/global/widget/language_change_dialog.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/page/user_profile/user_profile_basic_info.dart';
import 'package:eventjar/page/user_profile/user_profile_business_info.dart';
import 'package:eventjar/page/user_profile/user_profile_header.dart';
import 'package:eventjar/page/user_profile/user_profile_network_info.dart';
import 'package:eventjar/page/user_profile/user_profile_permissions.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_info.dart';
import 'package:eventjar/page/user_profile/user_profile_shimmer.dart';
import 'package:eventjar/page/user_profile/user_profile_social_links.dart';
import 'package:eventjar/page/user_profile/user_profile_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'my_profile'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            tooltip: 'Language',
            onPressed: () => showLanguageChangeDialog(context),
          ),
          Obx(() {
            final mode = ThemeStore.to.themeMode;
            final IconData icon = switch (mode) {
              ThemeMode.light => Icons.light_mode_rounded,
              ThemeMode.dark => Icons.dark_mode_rounded,
              ThemeMode.system => Icons.phone_android_rounded,
            };
            return PopupMenuButton<ThemeMode>(
              icon: Icon(icon, color: Colors.white),
              tooltip: 'Theme',
              onSelected: (selected) => ThemeStore.to.setThemeMode(selected),
              itemBuilder: (_) => [
                _buildThemeMenuItem(
                  ThemeMode.light,
                  Icons.light_mode_rounded,
                  'Light',
                  mode,
                ),
                _buildThemeMenuItem(
                  ThemeMode.dark,
                  Icons.dark_mode_rounded,
                  'Dark',
                  mode,
                ),
                _buildThemeMenuItem(
                  ThemeMode.system,
                  Icons.phone_android_rounded,
                  'System Default',
                  mode,
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            return controller.onTabOpen();
          },
          child: controller.state.isLoading.value
              ? userProfileBuildShimmerSkeleton()
              : GestureDetector(
                  onTap: () {
                    Get.focusScope?.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        UserProfileHeader(),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'basic_information'.tr,
                          child: userProfileBuildBasicInfo(),
                          isEditEnabled: true,
                          onEdit: () {
                            controller.navigateToBasicInfoUpdate();
                          },
                        ),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'business_information'.tr,
                          child: userProfileBuildBusinessInfo(),
                          isEditEnabled: true,
                          onEdit: () {
                            controller.navigateToBusinessInfoUpdate();
                          },
                        ),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'networking_and_interests'.tr,
                          child: userProfileBuildNetworkInfo(),
                          isEditEnabled: true,
                          onEdit: () {
                            controller.navigateToNetworkingInfoUpdate();
                          },
                        ),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'professional_summary'.tr,
                          child: userProfilebuildSummary(),
                          isEditEnabled: true,
                          onEdit: () {
                            controller.navigateToProfessionalSummaryUpdate();
                          },
                        ),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'social_and_contact_links'.tr,
                          child: userProfileBuildSocialLinks(),
                          isEditEnabled: true,
                          onEdit: () {
                            controller.navigateToSocialUpdate();
                          },
                        ),
                        SizedBox(height: 2.hp),
                        _buildGallerySection(context),
                        _buildNotificationsSection(context),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'app_permissions'.tr,
                          child: const UserProfilePermissions(),
                        ),
                        SizedBox(height: 2.hp),
                        _buildSection(
                          context,
                          title: 'security_and_sessions'.tr,
                          child: userProfileBuildSecurity(),
                        ),
                        // SizedBox(height: 2.hp),
                        _buildVersionFooter(context),
                        SizedBox(
                          height:
                              kBottomNavigationBarHeight +
                              MediaQuery.of(context).viewPadding.bottom +
                              2.hp,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildGallerySection(BuildContext ctx) {
    const int columns = 3;
    const int perPage = 6;
    const double spacing = 8;

    return Obx(() {
      final images = controller.galleryImages;
      final hasImages = images.isNotEmpty;
      final pageCount = hasImages ? (images.length / perPage).ceil() : 0;

      return Column(
        children: [
          _buildSection(
            ctx,
            title: hasImages ? "Gallery (${images.length})" : 'gallery'.tr,
            isEditEnabled: true,
            onEdit: () {
              controller.navigateToGalleryUpdate();
            },
            editIcon: hasImages ? Icons.edit_outlined : Icons.add_rounded,
            child: hasImages
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      final tileSize =
                          (constraints.maxWidth - spacing * (columns - 1)) /
                              columns;
                      final maxItems =
                          images.length > perPage ? perPage : images.length;
                      final rows = (maxItems / columns).ceil();
                      final gridHeight =
                          rows * tileSize + (rows - 1) * spacing;

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
                                          "fileUrl":
                                              getFileUrl(images[imgIndex]),
                                          "header": controller.displayName,
                                        },
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              getFileUrl(images[imgIndex]),
                                          fit: BoxFit.cover,
                                          width: tileSize,
                                          height: tileSize,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: AppColors.chipBg(context),
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                            color: AppColors.chipBg(context),
                                            child: Icon(
                                              Icons.broken_image_outlined,
                                              size: 28,
                                              color: AppColors.iconMuted(
                                                  context),
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
                                color: AppColors.textHint(ctx),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'tap_image_full_screen'.tr,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: AppColors.textHint(ctx),
                                ),
                              ),
                            ],
                          ),
                          if (pageCount > 1) ...[
                            SizedBox(height: 1.hp),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    List.generate(pageCount, (index) {
                                  final isActive =
                                      controller.state.galleryIndex.value ==
                                          index;
                                  return AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    width: isActive ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(4),
                                      color: isActive
                                          ? AppColors.gradientDarkStart
                                          : AppColors.gradientDarkStart
                                              .withValues(alpha: 0.2),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.hp),
                      child: Text(
                        "No gallery images yet",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.textSecondary(ctx),
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 2.hp),
        ],
      );
    });
  }

  Widget _buildNotificationsSection(BuildContext ctx) {
    return _buildSection(
      ctx,
      title: 'automation'.tr,
      child: GestureDetector(
        onTap: () {
          controller.navigateToConfigureNotification();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBlueBg(ctx),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightBlueBorder(ctx)),
          ),
          child: Row(
            children: [
              // Static icon (animation removed)
              Container(
                padding: EdgeInsets.all(1.wp),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Click to Configure Automations",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: AppColors.textPrimary(ctx),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Manage Email, WhatsApp automations",
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: AppColors.textSecondary(ctx),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isEditEnabled: false,
    );
  }

  Widget _buildSection(
    BuildContext ctx, {
    required String title,
    required Widget child,
    bool? isEditEnabled,
    VoidCallback? onEdit,
    IconData? editIcon,
  }) {
    final bool editEnabled = isEditEnabled ?? false;
    final IconData actionIcon = editIcon ?? Icons.edit_outlined;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(ctx),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(ctx),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(ctx),
                    ),
                  ),
                ),
                // Edit Icon Button (conditional)
                if (editEnabled && onEdit != null)
                  InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(1.5.wp),
                      child: Icon(
                        actionIcon,
                        size: 18.sp,
                        color: AppColors.iconMuted(ctx),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider(ctx)),
          Padding(padding: EdgeInsets.all(4.wp), child: child),
        ],
      ),
    );
  }

  Widget _buildVersionFooter(BuildContext ctx) {
    return Obx(() {
      final version = controller.state.appVersion.value;
      if (version.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 2.hp, top: 1.hp),
        child: Column(
          children: [
            Divider(
              thickness: 0.6,
              color: AppColors.divider(ctx),
              indent: 25.wp,
              endIndent: 25.wp,
            ),
            SizedBox(height: 1.hp),
            Text(
              'App Version $version',
              style: TextStyle(
                fontSize: 8.5.sp,
                color: AppColors.textHint(ctx),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 0.5.hp),
            Text(
              '© EventJar',
              style: TextStyle(
                fontSize: 7.5.sp,
                color: AppColors.textSecondary(ctx),
              ),
            ),
          ],
        ),
      );
    });
  }

  PopupMenuItem<ThemeMode> _buildThemeMenuItem(
    ThemeMode mode,
    IconData icon,
    String label,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.gradientDarkStart : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? AppColors.gradientDarkStart : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 18, color: AppColors.gradientDarkStart),
          ],
        ],
      ),
    );
  }
}
