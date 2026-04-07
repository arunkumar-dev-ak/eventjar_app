import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_form.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_pending_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget userProfileBuildSecurity() {
  final controller = Get.find<UserProfileController>();

  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBgStatic,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderStatic),
        ),
        child: Obx(() {
          bool is2FaEnabled =
              controller.state.userProfile.value?.twoFactorEnabled ?? false;
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(3.wp),
                decoration: BoxDecoration(
                  color: is2FaEnabled
                      ? (AppColors.isDark ? const Color(0xFF2A1010) : Colors.red.shade50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    if (is2FaEnabled) {
                      controller.showDisable2FaDialog();
                    } else {
                      controller.navigateToTwoFaPage();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        is2FaEnabled
                            ? Icons.shield_moon_outlined
                            : Icons.shield_outlined,
                        color: is2FaEnabled ? Colors.red : Colors.blue,
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              is2FaEnabled
                                  ? "Disable 2FA Authentication"
                                  : "Enable 2FA Authentication",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: is2FaEnabled ? Colors.red : AppColors.textPrimaryStatic,
                              ),
                            ),
                            Text(
                              is2FaEnabled
                                  ? "This will make your account less secure"
                                  : "Add extra security to your account",
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: AppColors.textSecondaryStatic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.iconMutedStatic,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.hp),
              Divider(color: AppColors.dividerStatic),
              SizedBox(height: 2.hp),

              // ===== Change Password =====
              InkWell(
                onTap: () {
                  controller.navigateToResetPassword();
                },
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: Colors.orange),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryStatic,
                            ),
                          ),
                          Text(
                            "Update your password regularly",
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.textSecondaryStatic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.iconMutedStatic),
                  ],
                ),
              ),
            ],
          );
        }),
      ),

      SizedBox(height: 2.hp),

      // Session Management
      Container(
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: AppColors.isDark ? const Color(0xFF2A2010) : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.isDark ? Colors.orange.shade800 : Colors.orange.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Icon(Icons.devices, color: Colors.orange.shade700),
            //     SizedBox(width: 3.wp),
            //     Text(
            //       "Active Sessions",
            //       style: TextStyle(
            //         fontSize: 10.sp,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.orange.shade700,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 1.hp),
            Text(
              "Manage your active session",
              style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondaryStatic),
            ),
            SizedBox(height: 2.hp),
            Obx(() {
              bool isLoading = controller.state.isLoggingOut.value;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          controller.handleLogout();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading
                        ? Colors.red.withValues(alpha: 0.6)
                        : Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 16),

                      SizedBox(width: 8),

                      Text(isLoading ? "Signing Out..." : "Sign Out"),

                      if (isLoading) ...[
                        SizedBox(width: 10),
                        SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      SizedBox(height: 2.hp),

      // Delete Button
      Obx(() {
        final response = controller.state.deleteAccountResponse.value;
        final isDeleted = response?.data.deletedAt != null;
        final isPending = response?.data.hasPendingDeletion == true;

        if (isDeleted) {
          return Container(
            padding: EdgeInsets.all(3.wp),
            decoration: BoxDecoration(
              color: AppColors.chipBgStatic,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderStatic),
            ),
            child: Row(
              children: [
                Icon(Icons.block, color: AppColors.iconMutedStatic),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Deleted",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryStatic,
                        ),
                      ),
                      Text(
                        "Your account has been permanently deleted",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.textHintStatic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final bgColor = isPending
            ? (AppColors.isDark ? const Color(0xFF0A2A1A) : Colors.green.shade50)
            : (AppColors.isDark ? const Color(0xFF2A1010) : Colors.red.shade50);
        final borderColor = isPending
            ? (AppColors.isDark ? Colors.green.shade800 : Colors.green.shade200)
            : (AppColors.isDark ? Colors.red.shade800 : Colors.red.shade200);
        final iconColor = isPending
            ? Colors.green.shade700
            : Colors.red.shade700;
        final arrowColor = iconColor;
        final titleColor = iconColor;
        final subtitleColor = isPending
            ? Colors.green.shade600
            : Colors.red.shade600;
        final iconData = isPending ? Icons.restore : Icons.delete_outline;

        return InkWell(
          onTap: () {
            controller.checkPopupView();
          },
          child: Container(
            padding: EdgeInsets.all(3.wp),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(iconData, color: iconColor),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${isPending ? "Reactivate" : "Deactivate"} Your Account",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      if (isPending)
                        Text(
                          "Account scheduled for deletion",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
              ],
            ),
          ),
        );
      }),
    ],
  );
}

void showDeletedAccountDialog(UserProfileController controller) {
  final response = controller.state.deleteAccountResponse.value;
  final deletedAt = response?.data.deletedAt;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: Container(
        padding: EdgeInsets.all(5.wp),
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Red X icon
            Icon(
              Icons.cancel_outlined,
              size: 40.sp,
              color: Colors.red.shade400,
            ),
            SizedBox(height: 16),

            // Title
            Text(
              "Account Deleted",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),

            SizedBox(height: 12),

            // Info
            Text(
              "Your account was permanently deleted on ${DateFormat('MMM dd, yyyy').format(deletedAt!)}",
              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondaryStatic),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24),

            // Close button only
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Close"),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(5.wp),
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Icon(
                hasPendingDeletion
                    ? Icons.schedule
                    : Icons.warning_amber_rounded,
                size: 30.sp,
                color: hasPendingDeletion ? Colors.orange : Colors.redAccent,
              ),
              SizedBox(height: 16),

              // Title
              Text(
                hasPendingDeletion ? "Reactivate Account" : "Delete Account",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: hasPendingDeletion ? Colors.orange : Colors.redAccent,
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
                style: TextStyle(fontSize: 8.5.sp, color: AppColors.textSecondaryStatic),
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
