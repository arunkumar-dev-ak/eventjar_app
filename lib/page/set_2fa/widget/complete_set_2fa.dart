import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:eventjar/global/responsive/responsive.dart';

Widget buildSet2faSuccess() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.wp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4.hp),

          // 🎉 Lottie Animation
          SizedBox(
            child: Lottie.asset(
              'assets/animations/success.json',
              repeat: false,
            ),
          ),

          SizedBox(height: 2.hp),

          // Title
          Text(
            "2FA Enabled Successfully!",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.5.hp),

          // Subtitle
          Text(
            "Your account is now protected with two-factor authentication.",
            style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondaryStatic),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.hp),
        ],
      ),
    ),
  );
}
