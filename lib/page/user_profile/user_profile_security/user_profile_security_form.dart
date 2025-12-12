import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountForm extends StatelessWidget {
  final bool hasPendingDeletion;

  const DeleteAccountForm({super.key, required this.hasPendingDeletion});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Password Field with validation colors
          TextFormField(
            controller: controller.passwordController,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: controller.formKey.currentState?.validate() == false
                      ? Colors.red.shade300
                      : Colors.blue.shade300,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade300, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade400, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: controller.formKey.currentState?.validate() == false
                      ? Colors.red.shade200
                      : Colors.grey.shade300,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              errorStyle: TextStyle(fontSize: 8.sp, color: Colors.red.shade600),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),

          SizedBox(height: 2.hp),

          DeleteDialogButtons(hasPendingDeletion: hasPendingDeletion),
        ],
      ),
    );
  }
}

class DeleteDialogButtons extends StatelessWidget {
  final controller = Get.find<UserProfileController>();
  final bool hasPendingDeletion;

  DeleteDialogButtons({super.key, required this.hasPendingDeletion});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDeleteLoading = controller.state.isDeleteLoading.value;
      final formKey = controller.formKey;
      final passwordController = controller.passwordController;
      return Row(
        children: [
          // Cancel Button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (isDeleteLoading) {
                  return;
                } else {
                  Get.back();
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 10.sp),
              ),
            ),
          ),
          SizedBox(width: 3.wp),

          // Delete/Reactivate Button
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (isDeleteLoading || !formKey.currentState!.validate()) {
                  return;
                }
                Get.focusScope?.unfocus();
                final password = passwordController.text.trim();
                await controller.handleDeleteAccount(
                  isReactivate: hasPendingDeletion,
                  password: password,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hasPendingDeletion
                    ? Colors.orange
                    : Colors.redAccent,
                foregroundColor: Colors.white,
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
                          "Processing...",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      hasPendingDeletion ? "Reactivate" : "Delete",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
