import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart' show AppColors;
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewTripAnalytics extends GetView<ViewTripController> {
  final bool showSettleUp;
  const ViewTripAnalytics({super.key, this.showSettleUp = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        border: Border.all(color: AppColors.budgetTabColor, width: 1.sp),
        borderRadius: BorderRadius.circular(12.sp),
      ),

      padding: EdgeInsets.all(4.wp),
      child: Obx(() {
        final yourSpent = controller.state.trip.value?.myShare ?? 0;
        final youOwe = controller.state.trip.value?.myOwe ?? 0;
        final youReceive = controller.state.trip.value?.myReceive ?? 0;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "your_spent".tr,
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: AppColors.budgetTabTextColor,
                        letterSpacing: 1.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      "₹${yourSpent.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ],
                ),
                if (showSettleUp)
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.sp),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.sp),
                      onTap: () {
                        HapticHelper.medium();
                        controller.changeTab(1);
                      },
                      child: Ink(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.5.wp,
                          vertical: 0.9.hp,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradientFor(context),
                          borderRadius: BorderRadius.circular(10.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.handshake_outlined,
                              size: 10.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 1.5.wp),
                            Text(
                              'settle_up'.tr,
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 1.5.hp),

            Row(
              children: [
                Expanded(
                  child: _amountCard(
                    context,
                    "you_owe".tr,
                    "₹${youOwe.toStringAsFixed(0)}",
                    isOwe: true,
                  ),
                ),
                SizedBox(width: 2.wp),
                Expanded(
                  child: _amountCard(
                    context,
                    "you_receive".tr,
                    "₹${youReceive.toStringAsFixed(0)}",
                    isOwe: false,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

Widget _amountCard(
  BuildContext context,
  String title,
  String amount, {
  required bool isOwe,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final Color accentColor = isOwe
      ? (isDark ? const Color(0xFFE57373) : const Color(0xFF8B1E1E))
      : (isDark ? const Color(0xFF66BB6A) : const Color(0xFF1E6B3A));

  return Container(
    padding: EdgeInsets.all(3.wp),
    decoration: BoxDecoration(
      color: AppColors.budgetTabColor,
      borderRadius: BorderRadius.circular(12.sp),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 7.sp,
            color: AppColors.budgetTabTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.5.hp),
        Text(
          amount,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
      ],
    ),
  );
}
