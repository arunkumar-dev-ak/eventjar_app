import 'package:eventjar_app/controller/checkout/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCheckoutPriceSummarySection() {
  final CheckoutController controller = Get.find();

  return Obx(() {
    final selectedTicket = controller.state.selectedTicketTier.value;
    final quantity = controller.state.quantity.value;
    final subtotal = selectedTicket != null
        ? double.parse(selectedTicket.price) * quantity
        : 0.0;
    final platformFee = 0.0; // Add platform fee logic if needed
    final total = subtotal + platformFee;

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
          // Section Title
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

          // Price Details Container
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
                // Subtotal
                _buildPriceRowWhite(
                  "Subtotal ($quantity ticket${quantity > 1 ? 's' : ''})",
                  "₹${subtotal.toStringAsFixed(2)}",
                ),
                SizedBox(height: 1.5.hp),

                // Platform Fee
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

                // Total
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
