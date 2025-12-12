import 'package:eventjar/controller/thank_you_message/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThankYouMessageActionButtons extends StatelessWidget {
  final ThankYouMessageController controller;

  const ThankYouMessageActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 2.hp),
                textStyle: TextStyle(fontSize: 9.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: controller.state.isLoading.value
                  ? null
                  : () => controller.resetForm(),
              child: Text('Reset', style: TextStyle(fontSize: 10.sp)),
            ),
          ),
          SizedBox(width: 2.wp),
          // Send Message Button
          Expanded(
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  textStyle: TextStyle(fontSize: 9.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  if (controller.state.isLoading.value) {
                    return;
                  }
                  if (controller.formKey.currentState?.validate() ?? false) {
                    Get.focusScope?.unfocus();
                    await controller.sendThankYouMessage(context);
                  }
                },
                child: controller.state.isLoading.value
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text('Send Message', style: TextStyle(fontSize: 10.sp)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
