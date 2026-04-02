import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationBuildTabs extends GetView<NotificationController> {
  const NotificationBuildTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(4.wp),
        child: Row(
          children: [
            NotificationTab(
              label: 'Email',
              count: 0,
              selected: controller.state.selectedTab.value == 0,
              onTap: () => controller.changeTab(0),
            ),
            SizedBox(width: 2.wp),
            NotificationTab(
              label: 'WhatsApp',
              count: 0,
              selected: controller.state.selectedTab.value == 1,
              onTap: () => controller.changeTab(1),
            ),
          ],
        ),
      );
    });
  }
}

class NotificationTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const NotificationTab({
    required this.label,
    required this.count,
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
