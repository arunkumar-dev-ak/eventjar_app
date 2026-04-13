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
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Top Row (Title + Amount)
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
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: 0.3.hp),
                    Text(
                      "Paid by $paidBy",
                      style: TextStyle(
                        fontSize: 7.5.sp,
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
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.hp),

          /// 🔥 Bottom Row
          Row(
            children: [
              /// Location Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.sp),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueBg(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 7.5.sp,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),

              SizedBox(width: 2.wp),

              /// Split Info
              Row(
                children: [
                  Icon(
                    Icons.group,
                    size: 14,
                    color: AppColors.iconMuted(context),
                  ),
                  SizedBox(width: 1.wp),
                  Text(
                    "Split between $splitCount",
                    style: TextStyle(
                      fontSize: 7.5.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
