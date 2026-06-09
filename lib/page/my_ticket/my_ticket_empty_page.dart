import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          'no_tickets_yet'.tr,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondaryStatic,
          ),
        ),
        SizedBox(height: 1.hp),
        Text(
          'register_events_tickets_desc'.tr,
          style: TextStyle(fontSize: 9.sp, color: AppColors.textHintStatic),
        ),
      ],
    ),
  );
}
