import 'dart:ui';

import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_basic_info.dart';
import 'package:eventjar/page/user_profile/user_profile_business_info.dart';
import 'package:eventjar/page/user_profile/user_profile_header.dart';
import 'package:eventjar/page/user_profile/user_profile_network_info.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            return controller.onTabOpen();
          },
          child: controller.state.isLoading.value
              ? userProfileBuildShimmerSkeleton()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      UserProfileHeader(),
                      SizedBox(height: 2.hp),
                      _buildSection(
                        title: "Basic Information",
                        child: userProfileBuildBasicInfo(),
                        isEditEnabled: true,
                        onEdit: () {
                          controller.navigateToBasicInfoUpdate();
                        },
                      ),
                      SizedBox(height: 2.hp),
                      _buildSection(
                        title: "Business Information",
                        child: userProfileBuildBusinessInfo(),
                        isEditEnabled: true,
                        onEdit: () {
                          controller.navigateToBusinessInfoUpdate();
                        },
                      ),
                      SizedBox(height: 2.hp),
                      _buildSection(
                        title: "Networking & Interests",
                        child: userProfileBuildNetworkInfo(),
                        isEditEnabled: true,
                        onEdit: () {
                          controller.navigateToNetworkingInfoUpdate();
                        },
                      ),
                      SizedBox(height: 2.hp),
                      _buildSection(
                        title: "Professional Summary",
                        child: userProfilebuildSummary(),
                        isEditEnabled: true,
                        onEdit: () {
                          controller.navigateToProfessionalSummaryUpdate();
                        },
                      ),
                      SizedBox(height: 2.hp),
                      _buildSection(
                        title: "Social & Contact Links",
                        child: userProfileBuildSocialLinks(),
                        isEditEnabled: true,
                        onEdit: () {
                          controller.navigateToSocialUpdate();
                        },
                      ),
                      SizedBox(height: 2.hp),
                      _buildNotificationsSection(),
                      SizedBox(height: 2.hp),
                      _buildSection(
                        title: "Security & Sessions",
                        child: userProfileBuildSecurity(),
                      ),
                      // SizedBox(height: 2.hp),
                      _buildVersionFooter(),
                      SizedBox(height: 2.hp),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: "Notifications",
      child: GestureDetector(
        onTap: () {
          controller.navigateToConfigureNotification();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100),
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
                      "Click to Configure Notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Manage Email, WhatsApp notifications",
                      style: TextStyle(fontSize: 8.sp, color: Colors.grey[600]),
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

  Widget _buildSection({
    required String title,
    required Widget child,
    bool? isEditEnabled,
    VoidCallback? onEdit,
  }) {
    // Get isEditEnabled from args if not provided
    final bool editEnabled = isEditEnabled ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
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
                      color: Colors.black87,
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
                        Icons.edit_outlined,
                        size: 18.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(padding: EdgeInsets.all(4.wp), child: child),
        ],
      ),
    );
  }

  Widget _buildVersionFooter() {
    return Obx(() {
      final version = controller.state.appVersion.value;
      if (version.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 2.hp, top: 1.hp),
        child: Column(
          children: [
            Divider(
              thickness: 0.6,
              color: Colors.grey.shade300,
              indent: 25.wp,
              endIndent: 25.wp,
            ),
            SizedBox(height: 1.hp),
            Text(
              'App Version $version',
              style: TextStyle(
                fontSize: 8.5.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 0.5.hp),
            Text(
              '© EventJar',
              style: TextStyle(fontSize: 7.5.sp, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    });
  }
}
