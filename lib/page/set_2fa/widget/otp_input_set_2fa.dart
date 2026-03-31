import 'package:eventjar/controller/set_2fa/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
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
          style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 2.hp),
        Pinput(
          length: 6,
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          onChanged: (_) => controller.updateOtpValidity(),
          defaultPinTheme: PinTheme(
            width: 45,
            height: 55,
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
