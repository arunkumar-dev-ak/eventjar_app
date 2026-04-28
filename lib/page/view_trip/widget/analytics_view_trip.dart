import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart' show AppColors;
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewTripAnalytics extends GetView<ViewTripController> {
  const ViewTripAnalytics({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.budgetTabColor, width: 1.sp),
        borderRadius: BorderRadius.circular(12.sp),
      ),

      padding: EdgeInsets.all(4.wp),
      child: Column(
        children: [
          // YOU SPENT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YOU SPENT",
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: AppColors.budgetTabTextColor,
                      letterSpacing: 1.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    "₹12,500",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.wp,
                  vertical: 0.8.hp,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  "Settle Up",
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.5.hp),

          // Amount
          Row(
            children: [
              Expanded(child: _amountCard("YOU OWE", "₹2,000", isOwe: true)),
              SizedBox(width: 2.wp),
              Expanded(
                child: _amountCard("YOU RECEIVE", "₹5,000", isOwe: false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _amountCard(String title, String amount, {required bool isOwe}) {
  final Color accentColor = isOwe
      ? const Color(0xFF8B1E1E)
      : const Color(0xFF1E6B3A);

  return Container(
    padding: EdgeInsets.all(3.wp),
    decoration: BoxDecoration(
      color: AppColors.budgetTabColor,
      borderRadius: BorderRadius.circular(12.sp),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 7.sp,
            color: AppColors.budgetTabTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.5.hp),
        Text(
          amount,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
      ],
    ),
  );
}
