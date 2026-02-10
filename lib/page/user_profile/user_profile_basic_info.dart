import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/user_profile/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

Widget userProfileBuildBasicInfo() {
  final controller = Get.find<UserProfileController>();

  return Column(
    children: [
      userProfilebuildInfoRow(
        icon: Icons.email,
        label: "Email Address",
        value: controller.email.isEmpty ? "N/A" : controller.email,
        iconColor: Colors.red,
      ),
      SizedBox(height: 2.hp),
      // Phone row with verification status on the right
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: userProfilebuildInfoRow(
              icon: Icons.phone,
              label: "Mobile Number",
              value:
                  controller.phone.isEmpty ? "Not provided" : controller.phone,
              iconColor: Colors.green,
            ),
          ),
          Obx(() {
            final isVerified = controller.isPhoneVerified;
            final hasPhone = controller.phone.isNotEmpty;

            if (!isVerified && !hasPhone) return const SizedBox.shrink();

            if (isVerified) {
              return Padding(
                padding: EdgeInsets.only(top: 0.5.hp),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 1.wp),
                    Text(
                      'Verified',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(top: 0.5.hp),
              child: GestureDetector(
                onTap: () => _showPhoneOtpDialog(Get.context!, controller),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.wp, vertical: 0.5.hp),
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      SizedBox(height: 2.hp),
      userProfilebuildInfoRow(
        icon: Icons.work,
        label: "Professional Title",
        value: controller.professionalTitle.isEmpty
            ? "Not specified"
            : controller.professionalTitle,
        iconColor: Colors.orange,
      ),
    ],
  );
}

void _showPhoneOtpDialog(
    BuildContext context, UserProfileController controller) async {
  final phone = controller.state.userProfile.value?.phone ??
      controller.state.userProfile.value?.phoneParsed?.fullNumber ??
      '';
  controller.resetOtpState();

  // Send OTP first
  await controller.sendPhoneOtp();

  if (!context.mounted) return;

  final pinController = TextEditingController();
  final focusNode = FocusNode();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 45),
              padding: const EdgeInsets.only(
                top: 55,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
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
                    'Verify Phone Number',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the 6-digit code sent to\n$phone',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.placeHolderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Pinput OTP field
                  Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: PinTheme(
                      width: 48,
                      height: 52,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 48,
                      height: 52,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.gradientDarkStart,
                          width: 2,
                        ),
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      width: 48,
                      height: 52,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Error message
                  Obx(() {
                    final error = controller.state.otpError.value;
                    if (error.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 8.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // Resend OTP
                  Obx(() {
                    final cooldown = controller.state.resendCooldown.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: AppColors.placeHolderColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: cooldown > 0 ||
                                  controller.state.isSendingOtp.value
                              ? null
                              : () => controller.sendPhoneOtp(),
                          child: Text(
                            cooldown > 0
                                ? 'Resend in ${cooldown}s'
                                : 'Resend',
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: cooldown > 0
                                  ? AppColors.placeHolderColor
                                  : AppColors.gradientDarkStart,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  // Verify button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: controller.state.isVerifyingOtp.value
                              ? null
                              : () async {
                                  final otp = pinController.text.trim();
                                  if (otp.length < 6) {
                                    controller.state.otpError.value =
                                        'Please enter the full 6-digit code';
                                    return;
                                  }
                                  final success =
                                      await controller.verifyPhoneOtp(otp);
                                  if (success && ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                  }
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient:
                                  controller.state.isVerifyingOtp.value
                                      ? AppColors.disabledButtonGradient
                                      : AppColors.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradientDarkEnd
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: controller.state.isVerifyingOtp.value
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
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

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Circle icon at top
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Icon(
                Icons.phone_android_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
      );
    },
  ).then((_) {
    pinController.dispose();
    focusNode.dispose();
  });
}
