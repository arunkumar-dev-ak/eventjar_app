import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCheckoutContinueButton() {
  final CheckoutController controller = Get.find();

  return Obx(() {
    final isCheckingEligibility = controller.state.isCheckingEligibility.value;
    final isRegistering = controller.state.isRegistering.value;
    final isEligible =
        controller.state.eligibilityResponse.value?.eligible ?? true;

    final isDisabled = isCheckingEligibility || !isEligible || isRegistering;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDisabled
            ? LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled
              ? null
              : () {
                  controller.proceedToCheckout();
                },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.hp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCheckingEligibility) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 2.wp),
                  Text(
                    "Checking eligibility...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else if (isRegistering) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 2.wp),
                  Text(
                    "Processing registration...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else if (!isEligible) ...[
                  Icon(Icons.block, color: Colors.white, size: 20),
                  SizedBox(width: 2.wp),
                  Text(
                    "Not Eligible to Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  Text(
                    "Continue to Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.wp),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  });
}
