import 'package:eventjar/controller/join_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinTripError extends GetView<JoinTripController> {
  const JoinTripError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.wp,
      color: AppColors.isDark ? AppColors.darkCard : AppColors.liteBlue,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 44,
                color: Colors.red.shade400,
              ),
            ),

            SizedBox(height: 3.hp),

            Obx(() => Text(
                  controller.state.errorMessage.value.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )),

            SizedBox(height: 1.5.hp),

            Text(
              'join_trip_error_desc'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 9.5.sp,
                height: 1.4,
              ),
            ),

            SizedBox(height: 4.hp),

            ElevatedButton.icon(
              onPressed: controller.goBack,
              icon: Icon(Icons.home_outlined, size: 20),
              label: Text(
                'go_home'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.wp,
                  vertical: 1.5.hp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
