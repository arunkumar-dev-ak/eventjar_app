import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget connectionReqEmptyPlaceholder({
  String message = "",
  IconData icon = Icons.mail_outline,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 1.hp),
        Icon(icon, size: 48, color: AppColors.iconMutedStatic),
        SizedBox(height: 1.hp),
        Text(
          message.isEmpty ? 'no_requests_found'.tr : message,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondaryStatic,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
