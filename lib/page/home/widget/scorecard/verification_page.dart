import 'dart:async';

import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class _SmsRetrieverImpl extends SmsRetriever {
  _SmsRetrieverImpl(this._smartAuth);
  final SmartAuth _smartAuth;

  @override
  bool get listenForMultipleSms => false;

  @override
  Future<String?> getSmsCode() async {
    final res = await _smartAuth.getSmsWithUserConsentApi();
    if (!res.hasData) return null;

    // Use auto-extracted code if smart_auth parsed it correctly
    final code = res.requireData.code;
    if (code != null && code.length == 6) return code;

    // Fallback: parse 6-digit OTP from the full message text
    // Handles WhatsApp/custom formats where auto-parse fails
    final sms = res.requireData.sms;
    final match = RegExp(r'\b\d{6}\b').firstMatch(sms);
    return match?.group(0);
  }

  @override
  Future<void> dispose() async {
    _smartAuth.removeUserConsentApiListener();
  }
}

List<Widget> scorecardBuildVerificationPages() {
  final HomeController controller = Get.find<HomeController>();
  final profile = controller.state.userProfile.value;
  if (profile == null) return [];

  final pending = <Widget>[];
  final completed = <Widget>[];

  // Phone verification
  if (!profile.phoneVerified) {
    pending.add(
      Obx(
        () => _buildActionPage(
          icon: Icons.phone_outlined,
          title: 'Verify number',
          subtitle: 'Confirm your phone number',
          buttonLabel: 'Verify',
          isLoading: controller.state.isSendingOtp.value,
          onTap: controller.state.isSendingOtp.value
              ? null
              : () async {
                  if (controller.state.isSendingOtp.value) return;
                  final success = await controller.sendPhoneOtp();
                  if (success) {
                    _showPhoneOtpDialog(Get.context!);
                  }
                },
        ),
      ),
    );
  } else {
    completed.add(
      _buildActionPage(
        icon: Icons.phone_outlined,
        title: 'Number verified',
        subtitle: 'Phone number confirmed',
        isCompleted: true,
      ),
    );
  }

  // Email verification
  if (!profile.isVerified) {
    pending.add(
      _buildActionPage(
        icon: Icons.email_outlined,
        title: 'Verify email',
        subtitle: 'Confirm your email address',
        buttonLabel: 'Verify',
        onTap: () => _showEmailVerifyDialog(Get.context!),
      ),
    );
  } else {
    completed.add(
      _buildActionPage(
        icon: Icons.email_outlined,
        title: 'Email verified',
        subtitle: 'Email address confirmed',
        isCompleted: true,
      ),
    );
  }

  // Add contact
  if (!controller.hasAddedContact) {
    pending.add(
      _buildActionPage(
        icon: Icons.person_add_outlined,
        title: 'Add first contact',
        subtitle: 'Start building your network',
        buttonLabel: 'Add',
        onTap: () => controller.navigateToAddContact(),
      ),
    );
  } else {
    completed.add(
      _buildActionPage(
        icon: Icons.person_add_outlined,
        title: 'Contact added',
        subtitle: 'First contact saved',
        isCompleted: true,
      ),
    );
  }

  // Unverified first, then verified
  return [...pending, ...completed];
}

Widget _buildActionPage({
  required IconData icon,
  required String title,
  required String subtitle,
  bool isLoading = false,
  String? buttonLabel,
  VoidCallback? onTap,
  bool isCompleted = false,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 5.wp),
        SizedBox(width: 2.wp),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 7.5.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isCompleted)
          Icon(Icons.check_circle, color: Colors.greenAccent, size: 5.wp),
        if (!isCompleted && buttonLabel != null) ...[
          SizedBox(width: 1.5.wp),
          GestureDetector(
            onTap: isLoading ? null : onTap,
            child: Opacity(
              opacity: isLoading ? 0.6 : 1, // 👈 disabled feel
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.5.wp,
                  vertical: 0.6.hp,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isLoading ? 'Verifying...' : buttonLabel,
                  style: TextStyle(
                    color: const Color(0xFF1565C0),
                    fontSize: isLoading ? 6.sp : 7.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

void _showPhoneOtpDialog(BuildContext context) async {
  final HomeController controller = Get.find<HomeController>();
  final phone = controller.state.userProfile.value?.phone ?? '';
  controller.resetOtpState();

  if (!context.mounted) return;

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final smsRetriever = _SmsRetrieverImpl(SmartAuth.instance);

  // Snapshot clipboard before dialog opens so we don't false-trigger
  final initialClipboard = (await Clipboard.getData('text/plain'))?.text ?? '';
  Timer? clipboardTimer;

  clipboardTimer = Timer.periodic(const Duration(milliseconds: 800), (_) async {
    // Stop if OTP already filled
    if (pinController.text.length == 6) {
      clipboardTimer?.cancel();
      return;
    }
    final clip = (await Clipboard.getData('text/plain'))?.text?.trim() ?? '';
    // Ignore unchanged or same as before dialog opened
    if (clip.isEmpty || clip == initialClipboard) return;
    final match = RegExp(r'\b\d{6}\b').firstMatch(clip);
    if (match != null) {
      pinController.text = match.group(0)!;
      clipboardTimer?.cancel();
    }
  });

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5.5.hp),
              padding: EdgeInsets.only(
                top: 7.hp,
                left: 6.wp,
                right: 6.wp,
                bottom: 3.hp,
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
                  SizedBox(height: 1.hp),
                  Text(
                    'Enter the 6-digit code sent to\n$phone',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.placeHolderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.5.hp),

                  // Pinput OTP field
                  Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    smsRetriever: smsRetriever,
                    defaultPinTheme: PinTheme(
                      width: 12.wp,
                      height: 6.5.hp,
                      textStyle: TextStyle(
                        fontSize: 12.sp,
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
                      width: 12.wp,
                      height: 6.5.hp,
                      textStyle: TextStyle(
                        fontSize: 12.sp,
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
                      width: 12.wp,
                      height: 6.5.hp,
                      textStyle: TextStyle(
                        fontSize: 12.sp,
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
                  SizedBox(height: 1.hp),

                  // Error message
                  Obx(() {
                    final error = controller.state.otpError.value;
                    if (error.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(top: 0.5.hp),
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

                  SizedBox(height: 1.5.hp),

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
                          onTap:
                              cooldown > 0 ||
                                  controller.state.isSendingOtp.value
                              ? null
                              : () => controller.sendPhoneOtp(),
                          child: Text(
                            cooldown > 0 ? 'Resend in ${cooldown}s' : 'Resend',
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

                  SizedBox(height: 3.hp),

                  // Verify button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 6.5.hp,
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
                                  final success = await controller
                                      .verifyPhoneOtp(otp);
                                  if (success && ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                  }
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: controller.state.isVerifyingOtp.value
                                  ? AppColors.disabledButtonGradient
                                  : AppColors.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradientDarkEnd.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: controller.state.isVerifyingOtp.value
                                  ? SizedBox(
                                      width: 5.5.wp,
                                      height: 5.5.wp,
                                      child: const CircularProgressIndicator(
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

                  SizedBox(height: 2.hp),
                ],
              ),
            ),

            // Circle icon at top
            Container(
              width: 22.wp,
              height: 22.wp,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: Colors.white,
                size: 9.wp,
              ),
            ),
          ],
        ),
      );
    },
  ).then((_) {
    clipboardTimer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    smsRetriever.dispose();
  });
}

void _showEmailVerifyDialog(BuildContext context) async {
  final HomeController controller = Get.find<HomeController>();
  final email = controller.state.userProfile.value?.email ?? '';

  final success = await controller.sendEmailVerification();
  if (!success || !context.mounted) return;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.hp),
            padding: EdgeInsets.only(
              top: 7.5.hp,
              left: 6.wp,
              right: 6.wp,
              bottom: 3.hp,
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
                  'Check your email',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.2.hp),
                Text(
                  'A verification link has been sent to\n$email',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.placeHolderColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.5.hp),
                InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.openEmailApp();
                  },
                  child: Container(
                    width: 90.wp,
                    height: 7.5.hp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: AppColors.buttonGradient,
                    ),
                    child: Center(
                      child: Text(
                        'Open Email',
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
          Container(
            width: 24.wp,
            height: 24.wp,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Icon(Icons.email, color: Colors.white, size: 10.wp),
          ),
        ],
      );
    },
  );
}
