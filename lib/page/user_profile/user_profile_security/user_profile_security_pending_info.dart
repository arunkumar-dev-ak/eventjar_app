import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePendingDeletionInfo extends StatelessWidget {
  final controller = Get.find<UserProfileController>();

  UserProfilePendingDeletionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final deleteResponse = controller.state.deleteAccountResponse.value;

      // Only show if has pending deletion and response exists
      if (deleteResponse?.data.hasPendingDeletion != true ||
          deleteResponse == null) {
        return SizedBox.shrink();
      }

      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Text(
                  "Your account is scheduled for deletion",
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                if (deleteResponse.data.remainingDays != null)
                  Text(
                    "${deleteResponse.data.remainingDays} days remaining",
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  "You can reactivate your account anytime before deletion",
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.hp),
        ],
      );
    });
  }
}
