import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 2.wp),
                SingleSelectFilterDropdown<MeetingStatus>(
                  title: 'status'.tr,
                  items: MeetingStatus.values,
                  selectedItem: isOneOnOneTab
                      ? controller.state.oneOnOneSelectedStatus
                      : controller.state.selectedStatus,
                  getDefaultItem: () => MeetingStatus.SCHEDULED,
                  getDisplayValue: (MeetingStatus status) => status.displayName,
                  getKeyValue: (MeetingStatus status) => status,
                  onSelected: (MeetingStatus status) {
                    if (isOneOnOneTab) {
                      controller.state.oneOnOneSelectedStatus.value = status;
                    } else {
                      controller.state.selectedStatus.value = status;
                    }
                  },
                  selectedTextSize: 8.sp,
                  textFieldPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 2.0,
                  ),
                  dropDownIconSize: 20,
                ),
                SizedBox(width: 2.wp),
                Obx(
                  () => DateRangeFilter(
                    selectedRange: isOneOnOneTab
                        ? controller.state.oneOnOneSelectedDateRange.value
                        : controller.state.selectedDateRange.value,
                    onRangeChanged: (range) {
                      if (isOneOnOneTab) {
                        controller.setOneOnOneDate(range);
                      } else {
                        controller.setDate(range);
                      }
                    },
                    displayText: isOneOnOneTab
                        ? controller.getOneOnOneDisplayText()
                        : controller.getDisplayText(),
                  ),
                ),
              ],
            ),
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

class DateRangeFilter extends GetView<MeetingController> {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onRangeChanged;
  final String? displayText;

  const DateRangeFilter({
    required this.selectedRange,
    required this.onRangeChanged,
    this.displayText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDateRangePicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border(context), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: 16,
              color: AppColors.textSecondary(context),
            ),
            SizedBox(width: 4),
            Text(
              displayText ?? controller.getDisplayText(),
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary(context),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: AppColors.textHint(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      initialDateRange:
          selectedRange ??
          DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 30)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
            colorScheme:
                (isDark ? const ColorScheme.dark() : const ColorScheme.light())
                    .copyWith(
                      primary: const Color(0xFF1A73E8),
                      onPrimary: Colors.white,
                      primaryContainer: const Color(0xFF1A73E8),
                      onPrimaryContainer: Colors.white,
                      secondaryContainer: const Color(0xFF1A73E8),
                      onSecondaryContainer: Colors.white,
                      surface: isDark ? AppColors.darkCard : Colors.white,
                      onSurface: isDark ? Colors.white : Colors.black87,
                    ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onRangeChanged(picked);
    }
  }
}
