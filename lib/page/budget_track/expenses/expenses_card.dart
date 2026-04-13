import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final int amount;
  final String paidBy;
  final String location;
  final int splitCount;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.location,
    required this.splitCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔥 MAIN CARD
        Container(
          margin: EdgeInsets.only(left: 1.5.wp), // space for border
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 1.5.hp),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 TOP ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title + Paid By
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        SizedBox(height: 0.4.hp),
                        Text(
                          "Paid by $paidBy",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Amount
                  Text(
                    "₹$amount",
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gradientDarkStart,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.2.hp),

              /// 🔥 BOTTOM ROW
              Row(
                children: [
                  /// Location Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.wp,
                      vertical: 0.7.hp,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBg(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),

                  SizedBox(width: 3.wp),

                  /// Split Info
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        size: 4.5.wp,
                        color: AppColors.iconMuted(context),
                      ),
                      SizedBox(width: 1.5.wp),
                      Text(
                        "Split $splitCount",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        /// 🔥 LEFT GRADIENT STRIP
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1.5.wp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkStart,
                  AppColors.gradientDarkEnd,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
