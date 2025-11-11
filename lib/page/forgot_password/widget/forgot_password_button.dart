import 'package:eventjar/controller/forgotPassword/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordSubmitButton extends StatelessWidget {
  final ForgotPasswordController controller =
      Get.find<ForgotPasswordController>();
  ForgotPasswordSubmitButton({super.key});

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
            borderRadius: BorderRadius.circular(16.0),
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
              onTap: () async {
                if (isButtonLoading) return;
                if (controller.formKey.currentState?.validate() ?? false) {
                  final currentContext = context;
                  final isSuccess = await controller.handleForgotPasswordSubmit(
                    currentContext,
                  );

                  if (isSuccess && currentContext.mounted) {
                    openModel(currentContext, onTap: controller.openEmailApp);
                  }
                }
              },
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: isButtonLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Continue",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
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

void openModel(BuildContext context, {required VoidCallback onTap}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          // ----- Bottom Sheet Container -----
          Container(
            margin: EdgeInsets.only(top: 50), // space for the circle
            padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Check your email',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'A password reset link has been sent to your email address.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.placeHolderColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 90.wp,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: AppColors.buttonGradient,
                    ),
                    child: Center(
                      child: Text(
                        'Check Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----- Circle with Email Icon -----
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Icon(Icons.email, color: Colors.white, size: 40),
          ),
        ],
      );
    },
  );
}
