import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCheckoutPriceSummarySection() {
  final controller = Get.find<CheckoutController>();

  return Obx(() {
    final lines = controller.state.cartLines;
    final subtotal = controller.subtotal;
    final platformFee = controller.platformFee;
    final total = controller.total;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.white, size: 20),
              SizedBox(width: 3.wp),
              Text(
                "Price Summary",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.hp),

          // Per-ticket lines
          Container(
            padding: EdgeInsets.all(3.wp),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // list rows like: Ticket A (x2)  ₹200.00
                ...lines.map((line) {
                  final price = double.tryParse(line.ticket.price) ?? 0;
                  final lineTotal = price * line.quantity.value;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.hp),
                    child: _buildPriceRowWhite(
                      "${line.ticket.name} (x${line.quantity.value})",
                      "₹${lineTotal.toStringAsFixed(2)}",
                    ),
                  );
                }).toList(),

                if (lines.isNotEmpty) SizedBox(height: 1.5.hp),

                // Subtotal
                _buildPriceRowWhite(
                  "Subtotal",
                  "₹${subtotal.toStringAsFixed(2)}",
                ),
                SizedBox(height: 1.5.hp),

                _buildPriceRowWhite(
                  "Platform Fee",
                  "₹${platformFee.toStringAsFixed(2)}",
                ),
                SizedBox(height: 1.5.hp),

                Divider(
                  color: Colors.white.withValues(alpha: 0.5),
                  thickness: 1,
                ),
                SizedBox(height: 1.5.hp),

                // Total line (same as before)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.wp,
                        vertical: 1.hp,
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
                        "₹${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildPriceRowWhite(String label, String amount) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
      Text(
        amount,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ],
  );
}
