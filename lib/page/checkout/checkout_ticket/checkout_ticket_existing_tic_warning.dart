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
        return Container(
          margin: EdgeInsets.only(bottom: 2.hp),
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(1.5.wp),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade700,
                  size: 16,
                ),
              ),
              SizedBox(width: 2.wp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Registration Notice",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    SizedBox(height: 0.3.hp),
                    Text(
                      reason,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.orange.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
}
