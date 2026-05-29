import 'package:eventjar/controller/google_calendar/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lottie/lottie.dart';

class GoogleCalendarLoadingView extends GetView<GoogleCalendarController> {
  const GoogleCalendarLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.wp,
      color: AppColors.scaffoldBg(context),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/auth_processing.json', width: 75.wp),

          SizedBox(height: 2.hp),

          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),

              child: Text(
                controller.state.loadingText.value,
                key: ValueKey(controller.state.loadingText.value),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 1.hp),

          Text(
            "Please wait while we verify your Google Calendar connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 10.sp,
            ),
          ),

          SizedBox(height: 4.hp),
        ],
      ),
    );
  }
}
