import 'package:eventjar/controller/signIn/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

void signInOpen2FAModal(
  BuildContext context, {
  required String email,
  required String tempToken,
  required SignInController controller,
}) {
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
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
            ),
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
                // Title
                Text(
                  'Two-Factor Authentication',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Email
                Text(
                  'Enter the 6-digit code from your authenticator app\nfor $email',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.placeHolderColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // 6 OTP Input Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: controller.otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.gradientDarkStart,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onChanged: (value) {
                          LoggerService.loggerInstance.dynamic_d(value);
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                          controller.updateOtpValidity();
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 10),

                // Clear code button (one line)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      controller.clear2FaController();
                      controller.updateOtpValidity();
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      'Clear code',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.gradientDarkStart,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Verify Button
                Obx(
                  () => SizedBox(
                    width: 90.wp,
                    height: 60,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap:
                            controller.state.is2FaLoading.value ||
                                !controller.state.isOtpValid.value
                            ? null
                            : () => controller.handleSubmit2fa(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient:
                                (!controller.state.isOtpValid.value ||
                                    controller.state.is2FaLoading.value)
                                ? AppColors.buttonGradient.withOpacity(0.6)
                                : AppColors.buttonGradient,
                          ),
                          child: Center(
                            child: controller.state.is2FaLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Verify',
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
                  ),
                ),
                SizedBox(height: 20),

                // Trouble text
                Text(
                  'Having trouble? Check your authenticator app for the latest code.',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.placeHolderColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // ----- Circle with Lock Icon -----
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Icon(Icons.lock_outline, color: Colors.white, size: 40),
          ),
        ],
      );
    },
  );
}
