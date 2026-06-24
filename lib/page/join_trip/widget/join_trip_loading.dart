import 'package:eventjar/controller/join_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class JoinTripLoading extends GetView<JoinTripController> {
  const JoinTripLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.wp,
      color: AppColors.isDark ? AppColors.darkCard : AppColors.liteBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/auth_processing.json',
            width: 90.wp,
          ),

          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Container(
                key: ValueKey(controller.state.loadingText.value),
                padding: EdgeInsets.symmetric(
                  horizontal: 6.wp,
                  vertical: 1.5.hp,
                ),
                child: Text(
                  controller.state.loadingText.value.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 1.hp),

          Text(
            'hang_tight_joining'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 10.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
