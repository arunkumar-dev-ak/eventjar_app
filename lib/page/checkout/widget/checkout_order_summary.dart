import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutOrderSummary extends GetView<CheckoutController> {
  const CheckoutOrderSummary({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subtotal = controller.subtotal;
      final platformFee = controller.platformFee;
      final total = controller.total;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp),
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Column(
          children: [
            _row("Subtotal", subtotal),
            SizedBox(height: 1.5.hp),
            _row("Platform Fee", platformFee),
            Divider(height: 3.hp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _row(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 10.sp)),
        Text("₹${value.toStringAsFixed(2)}", style: TextStyle(fontSize: 10.sp)),
      ],
    );
  }
}
