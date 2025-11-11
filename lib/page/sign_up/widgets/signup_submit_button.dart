import 'package:eventjar/controller/signUp/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpSubmitButton extends StatelessWidget {
  final SignUpController controller = Get.find<SignUpController>();
  SignUpSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      child: Obx(() {
        bool isButtonLoading = controller.state.isLoading.value;
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(16.0), // More rounded
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                if (isButtonLoading) return;
                if (controller.formKey.currentState?.validate() ?? false) {
                  controller.handleSignUpSubmit(context);
                  Get.focusScope?.unfocus();
                }
              },
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: isButtonLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Create Account",
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
