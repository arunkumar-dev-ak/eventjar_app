import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(4.wp),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.5.wp),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price Summary",
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${lines.length} ticket types in cart",
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price Details Card
              Container(
                margin: EdgeInsets.only(left: 4.wp, right: 4.wp, bottom: 4.wp),
                padding: EdgeInsets.all(4.wp),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    // Ticket Lines
                    ...lines.map((line) {
                      final price = double.tryParse(line.ticket.price) ?? 0;
                      final lineTotal = price * line.quantity.value;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.5.hp),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.5.wp),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.confirmation_number_outlined,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2.wp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    line.ticket.name,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Qty: ${line.quantity.value}",
                                    style: TextStyle(
                                      fontSize: 7.sp,
                                      color: Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "₹${lineTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    if (lines.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                      ),

                    // Subtotal
                    _buildPriceRow(
                      "Subtotal",
                      "₹${subtotal.toStringAsFixed(2)}",
                      isSubtle: true,
                    ),
                    SizedBox(height: 1.hp),

                    // Platform Fee
                    _buildPriceRow(
                      "Platform Fee",
                      "₹${platformFee.toStringAsFixed(2)}",
                      isSubtle: true,
                    ),
                    SizedBox(height: 1.5.hp),

                    // Total
                    Container(
                      padding: EdgeInsets.all(3.wp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(1.5.wp),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.payments_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2.wp),
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "₹${total.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gradientDarkStart,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

Widget _buildPriceRow(String label, String amount, {bool isSubtle = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          color: isSubtle
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.white,
          fontWeight: isSubtle ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      Text(
        amount,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ],
  );
}
