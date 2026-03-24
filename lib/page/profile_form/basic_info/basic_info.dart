import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/controller/profile_form/basic_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/profile_form/basic_info/basic_info_form_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
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

    final code = res.requireData.code;
    if (code != null && code.length == 6) return code;

    // Fallback: parse 6-digit OTP from full message text
    final sms = res.requireData.sms;
    final match = RegExp(r'\b\d{6}\b').firstMatch(sms);
    return match?.group(0);
  }

  @override
  Future<void> dispose() async {
    _smartAuth.removeUserConsentApiListener();
  }
}

class BasicInfoPage extends GetView<BasicInfoFormController> {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 10.sp;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SizedBox(
          width: 100.wp,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.hp),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  BasicInfoFormElement(
                    controller: controller.fullNameController,
                    label: 'Full Name',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      if (val.trim().length < 2) {
                        return 'Full name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.hp),

                  // Mobile Number
                  Obx(() {
                    return IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.blue.shade700,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                        ),
                        errorStyle: const TextStyle(height: 0),
                      ),
                      pickerDialogStyle: PickerDialogStyle(
                        countryNameStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                        ),
                        countryCodeStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      initialCountryCode:
                          controller.state.selectedCountry.value.code,
                      onChanged: (_) {},
                      onCountryChanged: (country) {
                        controller.state.selectedCountry.value = country;
                      },
                      controller: controller.mobileController,
                      validator: (value) {
                        if (value == null || !value.isValidNumber()) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    );
                  }),

                  // // Phone verification status
                  // Obx(() {
                  //   final isVerified = controller.state.isPhoneVerified.value;
                  //   final hasPhone =
                  //       controller.state.currentPhone.value.isNotEmpty;
                  //   if (!isVerified && !hasPhone) {
                  //     return const SizedBox.shrink();
                  //   }

                  //   return Padding(
                  //     padding: EdgeInsets.only(top: 0.8.hp),
                  //     child: Row(
                  //       children: [
                  //         if (isVerified) ...[
                  //           Icon(
                  //             Icons.check_circle,
                  //             color: Colors.green.shade600,
                  //             size: 18,
                  //           ),
                  //           const SizedBox(width: 6),
                  //           Text(
                  //             'Phone number verified',
                  //             style: TextStyle(
                  //               color: Colors.green.shade600,
                  //               fontSize: 8.sp,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ] else ...[
                  //           Icon(
                  //             Icons.info_outline,
                  //             color: Colors.orange.shade700,
                  //             size: 18,
                  //           ),
                  //           const SizedBox(width: 6),
                  //           Expanded(
                  //             child: Text(
                  //               'Phone not verified',
                  //               style: TextStyle(
                  //                 color: Colors.orange.shade700,
                  //                 fontSize: 8.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () => _showPhoneOtpDialog(context),
                  //             child: Container(
                  //               padding: EdgeInsets.symmetric(
                  //                 horizontal: 3.wp,
                  //                 vertical: 0.6.hp,
                  //               ),
                  //               decoration: BoxDecoration(
                  //                 gradient: AppColors.buttonGradient,
                  //                 borderRadius: BorderRadius.circular(8),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: AppColors.gradientDarkEnd
                  //                         .withValues(alpha: 0.25),
                  //                     blurRadius: 6,
                  //                     offset: const Offset(0, 2),
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Text(
                  //                 'Verify',
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 7.5.sp,
                  //                   fontWeight: FontWeight.w700,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ],
                  //     ),
                  //   );
                  // }),
                  SizedBox(height: 2.hp),

                  // Professional Title
                  BasicInfoFormElement(
                    controller: controller.professionalTitleController,
                    label: 'Professional Title',
                    validator: (val) => null, // Optional field
                  ),
                  SizedBox(height: 3.hp),

                  // Buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.clearForm,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.wp,
                              vertical: 1.8.hp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                            elevation: 0,
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: defaultFontSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;
                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Get.focusScope?.unfocus();
                                    controller.submitForm(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.wp,
                                vertical: 1.8.hp,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.blue.shade700.withValues(
                                alpha: 0.5,
                              ),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: defaultFontSize,
                                    width: defaultFontSize,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Update Info',
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPhoneOtpDialog(BuildContext context) async {
    final phone = controller.state.currentPhone.value;
    controller.resetOtpState();

    // Snapshot clipboard BEFORE sending OTP so any OTP copied during
    // the network call is detected as a new clipboard change
    final initialClipboard =
        (await Clipboard.getData('text/plain'))?.text ?? '';

    await controller.sendPhoneOtp();

    if (!context.mounted) return;

    final pinController = TextEditingController();
    final focusNode = FocusNode();
    final smsRetriever = _SmsRetrieverImpl(SmartAuth.instance);
    Timer? clipboardTimer;

    clipboardTimer = Timer.periodic(const Duration(milliseconds: 800), (_) async {
      if (pinController.text.length == 6) {
        clipboardTimer?.cancel();
        return;
      }
      final clip =
          (await Clipboard.getData('text/plain'))?.text?.trim() ?? '';
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

                    Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      smsRetriever: smsRetriever,
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
                            onTap:
                                cooldown > 0 ||
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
                                    final success = await controller
                                        .verifyPhoneOtp(otp);
                                    if (success && ctx.mounted) {
                                      Navigator.of(ctx).pop();
                                      AppSnackbar.success(
                                        title: "Verified",
                                        message:
                                            "Phone number verified successfully",
                                      );
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
      clipboardTimer?.cancel();
      smsRetriever.dispose();
      pinController.dispose();
      focusNode.dispose();
    });
  }
}
