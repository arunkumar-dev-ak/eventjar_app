import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String name;
  final String email;
  final int amount;
  final bool isOwed; // true = they owe you

  const BalanceCard({
    super.key,
    required this.name,
    required this.email,
    required this.amount,
    required this.isOwed,
  });

  String get initials =>
      name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// 🔥 Avatar
          Container(
            width: 32.sp,
            height: 32.sp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkStart.withValues(alpha: 0.7),
                  AppColors.gradientDarkEnd.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 3.wp),

          /// 🔥 Name + Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 0.4.hp),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isOwed ? "gets" : "owes",
                style: TextStyle(
                  fontSize: 7.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(height: 0.4.hp),
              Text(
                "₹$amount",
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.bold,
                  color: isOwed ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
