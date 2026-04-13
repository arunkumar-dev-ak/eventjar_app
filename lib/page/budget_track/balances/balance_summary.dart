import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceSummaryCard extends GetView<BudgetTrackController> {
  const BalanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOwed = controller.state.isOwedSelected.value;

      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.sp)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.sp),
          child: Row(
            children: [
              /// 🔥 LEFT — You are owed
              Expanded(
                child: GestureDetector(
                  onTap: controller.selectOwed,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      vertical: 1.5.hp,
                      horizontal: 2.wp,
                    ),
                    decoration: BoxDecoration(
                      color: isOwed
                          ? Colors.green.withValues(alpha: 0.08)
                          : Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Colors.green.withValues(alpha: 0.5),
                          width: 0.3.wp,
                        ),
                        left: BorderSide(
                          color: Colors.green.withValues(alpha: 0.5),
                          width: 0.3.wp,
                        ),
                        bottom: BorderSide(
                          color: Colors.green.withValues(alpha: 0.5),
                          width: 0.3.wp,
                        ),
                        right: BorderSide(
                          /// 🔥 dynamic divider
                          color: isOwed
                              ? Colors.green.withValues(alpha: 0.6)
                              : Colors.red.withValues(alpha: 0.6),
                          width: 0.3.wp,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Label
                        Text(
                          "You are owed",
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.withValues(
                              alpha: isOwed ? 1.0 : 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 0.5.hp),

                        /// Amount
                        Text(
                          "₹4,500",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.withValues(
                              alpha: isOwed ? 1.0 : 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 0.6.hp),

                        /// Indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isOwed ? 4.wp : 0,
                          height: isOwed ? 0.5.hp : 0,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔥 RIGHT — You owe
              Expanded(
                child: GestureDetector(
                  onTap: controller.selectOwe,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      vertical: 1.5.hp,
                      horizontal: 2.wp,
                    ),
                    decoration: BoxDecoration(
                      color: !isOwed
                          ? Colors.red.withValues(alpha: 0.08)
                          : Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Colors.red.withValues(alpha: 0.5),
                          width: 0.3.wp,
                        ),
                        right: BorderSide(
                          color: Colors.red.withValues(alpha: 0.5),
                          width: 0.3.wp,
                        ),
                        bottom: BorderSide(
                          color: Colors.red.withValues(alpha: 0.5),
                          width: 0.3.wp,
                        ),
                        left: BorderSide.none,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Label
                        Text(
                          "You owe",
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.withValues(
                              alpha: !isOwed ? 1.0 : 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 0.5.hp),

                        /// Amount
                        Text(
                          "₹1,200",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.withValues(
                              alpha: !isOwed ? 1.0 : 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 0.6.hp),

                        /// Indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: !isOwed ? 4.wp : 0,
                          height: !isOwed ? 0.5.hp : 0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(2.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
