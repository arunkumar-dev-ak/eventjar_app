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
    final isPaymentLoading = controller.state.isPaymentLoading.value;
    final isEligible =
        controller.state.eligibilityResponse.value?.eligible ?? true;

    final isDisabled = isCheckingEligibility || !isEligible || isRegistering || isPaymentLoading;
    final cartLines = controller.state.cartLines;
    final hasItems = cartLines.isNotEmpty &&
        cartLines.any((line) => line.quantity.value > 0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      child: Column(
        children: [
          // Main Button - styled like Book Now button
          Container(
            decoration: BoxDecoration(
              gradient: (isDisabled || !hasItems)
                  ? LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade400],
                    )
                  : AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: (isDisabled || !hasItems)
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.gradientDarkEnd.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: (isDisabled || !hasItems) ? null : () => controller.proceedToCheckout(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.5.wp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isCheckingEligibility) ...[
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.wp),
                        Text(
                          "Checking eligibility...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ] else if (isPaymentLoading) ...[
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.wp),
                        Text(
                          "Opening payment...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ] else if (isRegistering) ...[
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.wp),
                        Text(
                          "Processing...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ] else if (!isEligible) ...[
                        const Icon(
                          Icons.block_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 3.wp),
                        Text(
                          "Not Eligible to Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ] else if (!hasItems) ...[
                        const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 3.wp),
                        Text(
                          "Select Tickets to Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ] else ...[
                        const Icon(
                          Icons.payment_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 3.wp),
                        Text(
                          "Proceed to Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 2.wp),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Security Badge
          SizedBox(height: 1.5.hp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 14,
                color: Colors.green.shade600,
              ),
              SizedBox(width: 1.wp),
              Text(
                "Secure Payment",
                style: TextStyle(
                  fontSize: 7.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 3.wp),
              Icon(
                Icons.lock_rounded,
                size: 14,
                color: Colors.grey.shade400,
              ),
              SizedBox(width: 1.wp),
              Text(
                "SSL Encrypted",
                style: TextStyle(
                  fontSize: 7.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
}
