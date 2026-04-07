import 'package:eventjar/controller/set_2fa/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:pinput/pinput.dart';

class Set2faOtpInputSection extends GetView<Set2faController> {
  const Set2faOtpInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Enter the 6-digit code",
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 2.hp),
        Pinput(
          length: 6,
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          onChanged: (_) => controller.updateOtpValidity(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          defaultPinTheme: PinTheme(
            width: 45,
            height: 55,
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(context)),
            ),
          ),
        ),
      ],
    );
  }
}
