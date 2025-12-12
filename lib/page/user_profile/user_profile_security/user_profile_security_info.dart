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
      InkWell(
        onTap: () {
          controller.navigateToResetPassword();
        },
        child: Container(
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.blue.shade700),
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
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Text(
                      "Update your password regularly",
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 2.hp),

      // Session Management
      Container(
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
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
              style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade700),
            ),
            SizedBox(height: 2.hp),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.handleLogout();
                },
                icon: Icon(Icons.logout, size: 16),
                label: Text("Sign Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 2.hp),

      // Delete Button
      Obx(() {
        final isPending =
            controller
                .state
                .deleteAccountResponse
                .value
                ?.data
                .hasPendingDeletion ==
            true;

        final bgColor = isPending ? Colors.green.shade50 : Colors.red.shade50;
        final borderColor = isPending
            ? Colors.green.shade200
            : Colors.red.shade200;
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
                style: TextStyle(fontSize: 8.5.sp, color: Colors.grey[700]),
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
