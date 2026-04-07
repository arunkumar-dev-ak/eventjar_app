import 'package:eventjar/controller/auth_processing/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthProcessingSubmitButton extends GetView<AuthProcessingController> {
  const AuthProcessingSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      child: Obx(() {
        bool isButtonLoading = controller.state.isSubmitLoading.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () async {
                if (isButtonLoading) return;

                // Validate form and submit
                if (controller.state.formKey.currentState?.validate() ??
                    false) {
                  controller.submitMobileNumber();
                }
              },
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: isButtonLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
