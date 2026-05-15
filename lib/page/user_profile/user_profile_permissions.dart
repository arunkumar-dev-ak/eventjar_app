import 'dart:io';

import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePermissions extends GetView<UserProfileController> {
  const UserProfilePermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cameraOn = controller.state.cameraGranted.value;
      final notifOn = controller.state.notificationGranted.value;

      return Column(
        children: [
          _PermissionTile(
            icon: Icons.camera_alt_outlined,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.shade50,
            title: 'Camera',
            subtitle: cameraOn
                ? 'Camera access is enabled'
                : 'Required for QR scan & card scan',
            isEnabled: cameraOn,
            onTap: controller.toggleCameraPermission,
          ),
          Divider(height: 1, color: AppColors.divider(context)),
          _PermissionTile(
            icon: Icons.notifications_outlined,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.shade50,
            title: 'Notifications',
            subtitle: notifOn
                ? 'Push notifications are enabled'
                : 'Stay updated with contact activity',
            isEnabled: notifOn,
            onTap: controller.toggleNotificationPermission,
          ),
        ],
      );
    });
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.hp),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: 3.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Platform.isIOS
                ? CupertinoSwitch(
                    value: isEnabled,
                    activeTrackColor: AppColors.gradientLightStart,
                    onChanged: (_) => onTap(),
                  )
                : Switch(
                    value: isEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.gradientLightStart,
                    onChanged: (_) => onTap(),
                  ),
          ],
        ),
      ),
    );
  }
}
