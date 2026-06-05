import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String date;
  final int amount;
  final bool isReceived;

  const TransactionCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    final primaryText = AppColors.textPrimary(context);
    final mutedText = AppColors.textSecondary(context);

    return Container(
      padding: EdgeInsets.all(3.wp),
      margin: EdgeInsets.only(bottom: 1.2.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// 🔥 Avatar
          CircleAvatar(radius: 16.sp, child: Text(name[0])),

          SizedBox(width: 3.wp),

          /// 🔥 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReceived ? "${"received_from".tr} $name" : "${"paid_to".tr} $name",
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 8.sp, color: mutedText),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  date,
                  style: TextStyle(fontSize: 7.sp, color: mutedText),
                ),
              ],
            ),
          ),

          /// 🔥 Amount (NEW STYLE)
          Text(
            isReceived ? "+₹$amount" : "₹$amount",
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.bold,
              color: isReceived ? Colors.green : primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
