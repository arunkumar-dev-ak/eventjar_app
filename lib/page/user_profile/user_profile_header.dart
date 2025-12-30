import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileHeader extends StatelessWidget {
  final controller = Get.find<UserProfileController>();

  UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.state.userProfile.value;
    if (profile == null) return const SizedBox.shrink();

    final initials = _getInitials(controller.displayName);

    return Column(
      children: [
        // Cover Image + Avatar Section (LinkedIn style)
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Image
            Container(
              height: 14.hp,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
              ),
              child: Stack(
                children: [
                  // Decorative pattern
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Avatar positioned at bottom of cover
            Positioned(
              bottom: -50,
              left: 4.wp,
              child: _buildAvatar(initials),
            ),

            // Edit Profile Button
            Positioned(
              bottom: 8,
              right: 4.wp,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: AppColors.gradientDarkStart,
                    ),
                    SizedBox(width: 1.wp),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gradientDarkStart,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Space for avatar overflow
        SizedBox(height: 55),

        // Name, Title, Company Info
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Row with Verified Badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.displayName.isEmpty ? "N/A" : controller.displayName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                  if (controller.isVerified)
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified,
                        size: 18,
                        color: Colors.blue.shade600,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 0.5.hp),

              // Professional Title
              if (controller.professionalTitle.isNotEmpty)
                Text(
                  controller.professionalTitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              SizedBox(height: 0.5.hp),

              // Company & Location Row
              Row(
                children: [
                  if (controller.businessName.isNotEmpty) ...[
                    Icon(
                      Icons.business_rounded,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: 1.wp),
                    Flexible(
                      child: Text(
                        controller.businessName,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 3.wp),
                  ],
                  if (controller.state.userProfile.value?.location != null &&
                      controller.state.userProfile.value!.location!.isNotEmpty) ...[
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: 0.5.wp),
                    Flexible(
                      child: Text(
                        controller.state.userProfile.value!.location!,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 1.hp),

              // Role Badge
              _buildRoleBadge(),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "N/A";
    final parts = name.split(" ");
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _buildAvatar(String initials) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: controller.avatarUrl != null && controller.avatarUrl!.isNotEmpty
          ? CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                getFileUrl(controller.avatarUrl!),
              ),
            )
          : CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.gradientDarkStart,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.5.hp),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getRoleGradient(controller.role)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRoleIcon(controller.role), color: Colors.white, size: 14),
          SizedBox(width: 1.wp),
          Text(
            _getRoleDisplay(controller.role),
            style: TextStyle(
              fontSize: 7.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getRoleGradient(String role) {
    switch (role.toLowerCase()) {
      case 'organizer':
        return [Colors.deepPurple, Colors.purpleAccent];
      case 'admin':
        return [Colors.blue, Colors.lightBlueAccent];
      case 'user':
      default:
        return [Colors.green.shade600, Colors.green.shade400];
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.verified_user;
      case 'organizer':
        return Icons.event_available;
      case 'user':
      default:
        return Icons.person;
    }
  }

  String _getRoleDisplay(String role) {
    if (role.isEmpty) return "User";
    return role.capitalize ?? role;
  }
}
