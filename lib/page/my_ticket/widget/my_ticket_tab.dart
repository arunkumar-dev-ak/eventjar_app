import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketTabs extends GetView<MyTicketController> {
  const MyTicketTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Tabs
          Obx(() {
            return Row(
              children: [
                MyTicketTab(
                  label: "Upcoming",
                  selected: controller.state.selectedTab.value == 0,
                  onTap: () => controller.changeTab(0),
                ),
                SizedBox(width: 2.wp),
                MyTicketTab(
                  label: "Completed",
                  selected: controller.state.selectedTab.value == 1,
                  onTap: () => controller.changeTab(1),
                ),
              ],
            );
          }),

          /// Date Filter
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: controller.openDateFilter,
          ),
        ],
      ),
    );
  }
}

class MyTicketTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MyTicketTab({
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
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientDarkStart,
                    AppColors.gradientDarkStart.withValues(alpha: 0.8),
                  ],
                )
              : LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.gradientDarkStart
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.gradientDarkStart,
          ),
        ),
      ),
    );
  }
}
