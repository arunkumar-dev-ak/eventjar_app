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
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
      child: Row(
        children: [
          /* Tabs */
          Expanded(
            child: Obx(() {
              return Row(
                children: [
                  MyTicketTab(
                    label: 'Upcoming',
                    selected: controller.state.selectedTab.value == 0,
                    onTap: () => controller.changeTab(0),
                  ),
                  SizedBox(width: 3.wp),
                  MyTicketTab(
                    label: 'Completed',
                    selected: controller.state.selectedTab.value == 1,
                    onTap: () => controller.changeTab(1),
                  ),
                ],
              );
            }),
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
                    Colors.white.withValues(alpha: 0.7),
                    Colors.grey.shade100.withValues(alpha: 0.9),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.gradientDarkStart.withValues(alpha: 0.2)
                : Colors.grey.shade300,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.gradientDarkStart.withValues(alpha: 0.75),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 8.5.sp,
                shadows: selected
                    ? [
                        Shadow(
                          color: AppColors.gradientDarkStart.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
