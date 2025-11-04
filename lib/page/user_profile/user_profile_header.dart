import 'package:eventjar_app/controller/user_profile/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 3.hp),
          _buildAvatar(initials),
          SizedBox(height: 2.hp),
          _buildName(),
          SizedBox(height: 0.5.hp),
          _buildCompanyAndRole(),
          SizedBox(height: 3.hp),
        ],
      ),
    );
  }

  // Helper to get initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return "N/A";
    final parts = name.split(" ");
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Avatar section with verified badge
  Widget _buildAvatar(String initials) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue.shade200, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              controller.avatarUrl != null && controller.avatarUrl!.isNotEmpty
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(controller.avatarUrl!),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
        ),
        if (controller.isVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(1.5.wp),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }

  // Display Name
  Widget _buildName() {
    return Text(
      controller.displayName.isEmpty ? "N/A" : controller.displayName,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Company name and role tag
  Widget _buildCompanyAndRole() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (controller.businessName.isNotEmpty) ...[
          Text(
            controller.businessName,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.wp),
        ],
        _buildRoleChip(),
      ],
    );
  }

  // Role chip widget
  Widget _buildRoleChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.3.hp),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getRoleGradient(controller.role)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(_getRoleIcon(controller.role), color: Colors.white, size: 12),
          SizedBox(width: 1.wp),
          Text(
            _getRoleDisplay(controller.role),
            style: TextStyle(
              fontSize: 7.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //  Role gradient (dummy mapping — customize)
  List<Color> _getRoleGradient(String role) {
    switch (role.toLowerCase()) {
      case 'organizer':
        return [Colors.deepPurple, Colors.purpleAccent];
      case 'admin':
        return [Colors.blue, Colors.lightBlueAccent];
      case 'user':
      default:
        return [Colors.green, Colors.lightGreen];
    }
  }

  // Role icon
  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.verified_user;
      case 'manager':
        return Icons.manage_accounts;
      case 'user':
      default:
        return Icons.person;
    }
  }

  // Role text
  String _getRoleDisplay(String role) {
    if (role.isEmpty) return "User";
    return role.capitalize ?? role;
  }
}
