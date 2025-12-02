import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
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
      InkWell(
        onTap: () {
          userProfileShowDeleteAccountDialog(controller);
        },
        child: Container(
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red.shade700),
              SizedBox(width: 3.wp),
              Expanded(
                child: Text(
                  "Deactivate Your Account",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.red.shade700,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void userProfileShowDeleteAccountDialog(UserProfileController controller) {
  Get.dialog(
    Obx(() {
      final isDeleteLoading = controller.state.isDeleteLoading.value;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.wp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 30.sp,
                color: Colors.redAccent,
              ),
              SizedBox(height: 16),
              Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 1.5.hp),
              Text(
                "If you delete your account, all your data will be permanently lost. This action cannot be undone.",
                style: TextStyle(fontSize: 8.5.sp, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.hp),
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isDeleteLoading ? null : () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.wp),
                  // Delete button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isDeleteLoading
                          ? null
                          : () {
                              controller.handleDeleteAccount();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: isDeleteLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Deleting...",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }),
    barrierDismissible: false, // Prevent outside touch dismiss
  );
}
