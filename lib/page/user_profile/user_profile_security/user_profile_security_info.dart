import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_form.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_pending_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfileBuildSecurity() {
  final controller = Get.find<UserProfileController>();

  return Column(
    children: [
      // Change Password
      _buildSettingsTile(
        icon: Icons.lock_outline_rounded,
        title: "Change Password",
        subtitle: "Update your password regularly",
        iconColor: Colors.blue,
        onTap: () => controller.navigateToResetPassword(),
      ),

      SizedBox(height: 1.5.hp),

      // Sign Out Button
      _buildSettingsTile(
        icon: Icons.logout_rounded,
        title: "Sign Out",
        subtitle: "End your current session",
        iconColor: Colors.orange,
        onTap: () => controller.handleLogout(),
        showArrow: false,
      ),

      SizedBox(height: 1.5.hp),

      // Delete/Reactivate Account
      Obx(() {
        final isPending =
            controller.state.deleteAccountResponse.value?.data.hasPendingDeletion == true;

        return _buildSettingsTile(
          icon: isPending ? Icons.restore_rounded : Icons.person_off_outlined,
          title: isPending ? "Reactivate Account" : "Deactivate Account",
          subtitle: isPending
              ? "Account scheduled for deletion"
              : "Temporarily disable your account",
          iconColor: isPending ? Colors.green : Colors.red,
          onTap: () => controller.checkPopupView(),
          isDanger: !isPending,
        );
      }),
    ],
  );
}

Widget _buildSettingsTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color iconColor,
  required VoidCallback onTap,
  bool showArrow = true,
  bool isDanger = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.5.wp),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: isDanger ? iconColor : Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
        ],
      ),
    ),
  );
}

void userProfileShowDeleteAccountDialog(
  UserProfileController controller, {
  bool isReactivate = false,
}) {
  final deleteResponse = controller.state.deleteAccountResponse.value;
  final hasPendingDeletion = deleteResponse?.data.hasPendingDeletion ?? false;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Container(
          padding: EdgeInsets.all(5.wp),
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                padding: EdgeInsets.all(4.wp),
                decoration: BoxDecoration(
                  color: hasPendingDeletion
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasPendingDeletion
                      ? Icons.restore_rounded
                      : Icons.warning_amber_rounded,
                  size: 28.sp,
                  color: hasPendingDeletion ? Colors.orange : Colors.redAccent,
                ),
              ),
              SizedBox(height: 2.hp),

              // Title
              Text(
                hasPendingDeletion ? "Reactivate Account" : "Deactivate Account",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              SizedBox(height: 1.5.hp),

              // Status Info (if pending deletion)
              UserProfilePendingDeletionInfo(),

              // Warning message
              Text(
                hasPendingDeletion
                    ? "Enter your password to reactivate your account"
                    : "Account will be scheduled for deletion in 30 days. You can reactivate anytime before permanent deletion.",
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.hp),

              // Password Field
              DeleteAccountForm(hasPendingDeletion: hasPendingDeletion),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
