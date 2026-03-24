import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutBottomBar extends GetView<CheckoutController> {
  const CheckoutBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.total;
      final isLoading = controller.state.isRegistering.value;
      final bool isBadgeChecking = controller.state.isCheckingBadge.value;

      final hasTicket = controller.state.cartLines.isNotEmpty;

      final badgeResponse = controller.state.badgeValidationResponse.value;

      final bool isEligible = badgeResponse?.eligible ?? true;

      /// Button enabled condition
      final bool canProceed = hasTicket && isEligible && !isLoading;

      /// Button label logic
      String buttonText;

      if (isBadgeChecking) {
        buttonText = "Verifying Badge...";
      } else if (!hasTicket) {
        buttonText = "Select Ticket to Continue";
      } else if (isLoading) {
        buttonText = total == 0 ? "Booking..." : "Processing...";
      } else {
        buttonText = total == 0 ? "Click to Book Ticket" : "Proceed to Pay";
      }

      return Container(
        padding: EdgeInsets.fromLTRB(4.wp, 2.hp, 4.wp, 2.hp),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Total Section
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 2.wp),

              /// Button
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 65.wp, // limit button width
                ),
                child: ElevatedButton(
                  onPressed: canProceed
                      ? () => controller.proceedToCheckout()
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.wp,
                      vertical: 1.8.hp,
                    ),
                    backgroundColor: canProceed
                        ? (total == 0 ? Colors.blue : Colors.green)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading || isBadgeChecking)
                        Container(
                          margin: EdgeInsets.only(right: 2.wp),
                          width: 14,
                          height: 14,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),

                      Flexible(
                        child: Text(
                          buttonText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class PremiumBadgeStatusBanner extends GetView<CheckoutController> {
  const PremiumBadgeStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isChecking = controller.state.isCheckingBadge.value;
      final response = controller.state.badgeValidationResponse.value;

      final bool isEligible = response?.eligible ?? true;
      final String? failureReason = response?.reason;

      Color bgColor;
      Color textColor;
      IconData icon;
      String message;

      if (isChecking) {
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        icon = Icons.hourglass_top;
        message = "Checking badge verification...";
      } else if (!isEligible) {
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.cancel;

        /// 🔥 Use backend reason if available
        message = (failureReason != null && failureReason.isNotEmpty)
            ? failureReason
            : "Badge verification failed";
      } else {
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        icon = Icons.verified;
        message = "Badge verification successful";
      }

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.6.hp, horizontal: 4.wp),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(
              color: textColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isChecking)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            else
              Icon(icon, size: 18, color: textColor),

            SizedBox(width: 2.5.wp),

            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
