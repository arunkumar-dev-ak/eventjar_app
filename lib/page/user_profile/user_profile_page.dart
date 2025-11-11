import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_basic_info.dart';
import 'package:eventjar/page/user_profile/user_profile_business_info.dart';
import 'package:eventjar/page/user_profile/user_profile_header.dart';
import 'package:eventjar/page/user_profile/user_profile_location.dart';
import 'package:eventjar/page/user_profile/user_profile_network_info.dart';
import 'package:eventjar/page/user_profile/user_profile_security_info.dart';
import 'package:eventjar/page/user_profile/user_profile_social_links.dart';
import 'package:eventjar/page/user_profile/user_profile_summary.dart';
import 'package:flutter/material.dart';
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
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        // Loading state
        if (controller.state.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Profile loaded
        return SingleChildScrollView(
          child: Column(
            children: [
              UserProfileHeader(),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Basic Information",
                child: userProfileBuildBasicInfo(),
              ),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Business Information",
                child: userProfileBuildBusinessInfo(),
              ),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Location & Regions",
                child: userProfileBuildLocationInfo(),
              ),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Networking & Interests",
                child: userProfileBuildNetworkInfo(),
              ),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Professional Summary",
                child: userProfilebuildSummary(),
              ),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Social & Contact Links",
                child: userProfileBuildSocialLinks(),
              ),
              SizedBox(height: 2.hp),
              _buildSection(
                title: "Security & Sessions",
                child: userProfileBuildSecurity(),
              ),
              SizedBox(height: 4.hp),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
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
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(padding: EdgeInsets.all(4.wp), child: child),
        ],
      ),
    );
  }
}
