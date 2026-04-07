import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.confirmation_number_outlined,
          size: 64,
          color: AppColors.iconMutedStatic,
        ),
        SizedBox(height: 2.hp),
        Text(
          "No tickets yet",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondaryStatic,
          ),
        ),
        SizedBox(height: 1.hp),
        Text(
          "Register for events to see your tickets here",
          style: TextStyle(fontSize: 9.sp, color: AppColors.textHintStatic),
        ),
      ],
    ),
  );
}
