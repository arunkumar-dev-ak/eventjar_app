import 'package:eventjar/controller/connection/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionBuildTabs extends GetView<ConnectionController> {
  const ConnectionBuildTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ConnectionTab(
                label: 'Sent',
                count: controller.state.sendCount.value,
                selected: controller.state.selectedTab.value == 0,
                onTap: () => controller.changeTab(0),
              ),
              SizedBox(width: 2.wp),
              ConnectionTab(
                label: 'Received',
                count: controller.state.receivedCount.value,
                selected: controller.state.selectedTab.value == 1,
                onTap: () => controller.changeTab(1),
              ),
            ],
          ),

          SizedBox(width: 2.wp),

          SingleSelectFilterDropdown<String>(
            title: 'Filter Status',
            items: controller.state.statusItems,
            selectedItem: controller.state.selectedStatus,
            getDefaultItem: () => 'All',
            getDisplayValue: (String status) {
              return capitalize(status.toString());
            },
            getKeyValue: (String status) {
              return status;
            },
            onSelected: (String status) {
              controller.state.selectedStatus.value = status;
            },
            selectedTextSize: 8.sp,
            textFieldPadding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 2.0,
            ),
            dropDownIconSize: 20,
          ),
        ],
      );
    });
  }
}

class ConnectionTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const ConnectionTab({
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

            // SizedBox(width: 2.wp),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1.5.sp),
            //   decoration: BoxDecoration(
            //     color: selected
            //         ? AppColors.gradientDarkStart.withValues(alpha: 0.95)
            //         : Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(
            //       color: selected
            //           ? Colors.white.withValues(alpha: 0.3)
            //           : AppColors.gradientDarkStart.withValues(alpha: 0.2),
            //       width: 0.8,
            //     ),
            //     boxShadow: selected
            //         ? [
            //             BoxShadow(
            //               color: AppColors.gradientDarkStart.withValues(
            //                 alpha: 0.4,
            //               ),
            //               blurRadius: 3,
            //               offset: const Offset(0, 1),
            //             ),
            //           ]
            //         : null,
            //   ),
            //   child: Text(
            //     count.toString(),
            //     style: TextStyle(
            //       fontSize: 7.sp,
            //       fontWeight: FontWeight.bold,
            //       color: selected ? Colors.white : AppColors.gradientDarkStart,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
