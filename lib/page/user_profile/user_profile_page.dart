import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_basic_info.dart';
import 'package:eventjar/page/user_profile/user_profile_business_info.dart';
import 'package:eventjar/page/user_profile/user_profile_header.dart';
import 'package:eventjar/page/user_profile/user_profile_location.dart';
import 'package:eventjar/page/user_profile/user_profile_network_info.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_info.dart';
import 'package:eventjar/page/user_profile/user_profile_social_links.dart';
import 'package:eventjar/page/user_profile/user_profile_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        // Loading state
        if (controller.state.isLoading.value) {
          return SafeArea(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.gradientDarkStart,
              ),
            ),
          );
        }

        // Profile loaded
        return SingleChildScrollView(
          child: Column(
            children: [
              // LinkedIn-style header (no AppBar, full bleed)
              UserProfileHeader(),

              SizedBox(height: 2.hp),

              // Contact Info Card
              _buildSection(
                icon: Icons.person_outline_rounded,
                title: "Contact Info",
                child: userProfileBuildBasicInfo(),
              ),

              SizedBox(height: 1.5.hp),

              // About Section
              _buildSection(
                icon: Icons.info_outline_rounded,
                title: "About",
                child: userProfilebuildSummary(),
              ),

              SizedBox(height: 1.5.hp),

              // Experience / Business Section
              _buildSection(
                icon: Icons.business_center_outlined,
                title: "Experience",
                child: userProfileBuildBusinessInfo(),
              ),

              SizedBox(height: 1.5.hp),

              // Location Section
              _buildSection(
                icon: Icons.location_on_outlined,
                title: "Location",
                child: userProfileBuildLocationInfo(),
              ),

              SizedBox(height: 1.5.hp),

              // Skills & Interests Section
              _buildSection(
                icon: Icons.interests_outlined,
                title: "Skills & Interests",
                child: userProfileBuildNetworkInfo(),
              ),

              SizedBox(height: 1.5.hp),

              // Social Links Section
              _buildSection(
                icon: Icons.link_rounded,
                title: "Social Links",
                child: userProfileBuildSocialLinks(),
              ),

              SizedBox(height: 1.5.hp),

              // Settings & Security Section
              _buildSection(
                icon: Icons.settings_outlined,
                title: "Settings",
                child: userProfileBuildSecurity(),
              ),

              SizedBox(height: 4.hp),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.fromLTRB(4.wp, 3.wp, 4.wp, 2.wp),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.wp),
                  decoration: BoxDecoration(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColors.gradientDarkStart,
                  ),
                ),
                SizedBox(width: 3.wp),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: child,
          ),
        ],
      ),
    );
  }
}
