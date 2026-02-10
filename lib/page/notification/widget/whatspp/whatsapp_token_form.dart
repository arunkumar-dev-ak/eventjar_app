import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsAppTokenForm extends GetView<NotificationController> {
  const WhatsAppTokenForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "Mybotify Integration Token",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
          ),

          SizedBox(height: 0.6.hp),

          Text(
            "Paste your Mybotify WhatsApp API token below to enable notifications.",
            style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade600),
          ),

          SizedBox(height: 3.hp),

          // Token Input
          Obx(
            () => TextFormField(
              controller: controller.tokenController,
              obscureText: !controller.state.isTokenVisible.value,
              style: TextStyle(fontSize: 10.sp),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Token is required";
                }
                if (value.trim().length <= 10) {
                  return "Token must be greater than 10 characters";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Integration Token",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.lock_outline, size: 18.sp),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.state.isTokenVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 15.sp,
                  ),
                  onPressed: () {
                    controller.state.isTokenVisible.toggle();
                  },
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 1.6.hp,
                  horizontal: 3.wp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.green.shade400,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 3.hp),

          /// Helper text
          Row(
            children: [
              Icon(
                Icons.verified_user,
                size: 14.sp,
                color: Colors.green.shade600,
              ),
              SizedBox(width: 1.5.wp),
              Expanded(
                child: Text(
                  "Token is securely encrypted and never shared.",
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.4.hp),

          /// Save Button
          Obx(() {
            final isLoading = controller.state.isSavingToken.value;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : controller.saveToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(vertical: 1.7.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 2.wp),
                          Text(
                            "Saving Token...",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save_outlined, color: Colors.white),
                          SizedBox(width: 2.wp),
                          Text(
                            "Save Token",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
