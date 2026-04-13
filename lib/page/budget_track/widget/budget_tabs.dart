import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetTabs extends GetView<BudgetTrackController> {
  const BudgetTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TabBar(
        controller: controller.tabController,
        isScrollable: true,

        indicator: const BoxDecoration(),
        indicatorWeight: 0,
        dividerColor: Colors.transparent,

        padding: EdgeInsets.symmetric(horizontal: 1.wp),
        labelPadding: EdgeInsets.only(right: 8.wp),
        tabAlignment: TabAlignment.start,

        tabs: List.generate(controller.tabs.length, (index) {
          final selected = controller.state.selectedMainTab.value == index;

          return Tab(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TEXT
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 70),
                  style: TextStyle(
                    fontSize: selected ? 9.5.sp : 9.sp,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppColors.gradientDarkStart
                        : AppColors.textSecondary(context),
                  ),
                  child: Text(controller.tabs[index]),
                ),

                SizedBox(height: 0.6.hp),

                // GRADIENT UNDERLINE
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 3,
                  width: selected ? 24 : 0,
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradientFor(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
