import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutTicketExistingTicketWarning extends GetView<CheckoutController> {
  const CheckoutTicketExistingTicketWarning({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasExistingTicket =
          controller.state.eligibilityResponse.value?.eligible == false;
      final reason = controller.state.eligibilityResponse.value?.reason;

      if (hasExistingTicket && reason != null) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.orange.shade700,
                  size: 18,
                ),
                SizedBox(width: 2.wp),
                Expanded(
                  child: Text(
                    reason,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.hp),
          ],
        );
      }
      return SizedBox.shrink();
    });
  }
}
