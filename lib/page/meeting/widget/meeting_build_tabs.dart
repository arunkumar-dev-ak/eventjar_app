import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting/widget/meeting_date_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingBuildTabs extends GetView<MeetingController> {
  const MeetingBuildTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Row(
            children: [
              MeetingTab(
                label: 'one_on_one'.tr,
                selected: controller.state.selectedTab.value == 0,
                onTap: () => controller.changeTab(0),
              ),
              SizedBox(width: 2.wp),
              MeetingTab(
                label: 'qualified_contacts'.tr,
                selected: controller.state.selectedTab.value == 1,
                onTap: () => controller.changeTab(1),
              ),
            ],
          );
        }),
        SizedBox(height: 1.5.hp),
        Obx(() {
          final isOneOnOneTab = controller.state.selectedTab.value == 0;
          return MeetingDateSelector(
            selectedDate: isOneOnOneTab
                ? controller.state.oneOnOneSelectedDate
                : controller.state.qualifiedSelectedDate,
            displayedMonth: isOneOnOneTab
                ? controller.state.oneOnOneDisplayedMonth
                : controller.state.qualifiedDisplayedMonth,
            displayedYear: isOneOnOneTab
                ? controller.state.oneOnOneDisplayedYear
                : controller.state.qualifiedDisplayedYear,
            onPreviousMonth: isOneOnOneTab
                ? controller.oneOnOnePreviousMonth
                : controller.qualifiedPreviousMonth,
            onNextMonth: isOneOnOneTab
                ? controller.oneOnOneNextMonth
                : controller.qualifiedNextMonth,
            onSetMonthYear: isOneOnOneTab
                ? controller.setOneOnOneMonthYear
                : controller.setQualifiedMonthYear,
          );
        }),
      ],
    );
  }
}

class MeetingTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MeetingTab({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2.5.sp),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientDarkStart,
                    AppColors.gradientDarkStart.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    AppColors.cardBg(context).withValues(alpha: 0.7),
                    AppColors.chipBg(context).withValues(alpha: 0.9),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.gradientDarkStart.withValues(alpha: 0.2)
                : AppColors.border(context),
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.25),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary(context),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 8.5.sp,
            shadows: selected
                ? [
                    Shadow(
                      color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
