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
    return Row(
      children: [
        SizedBox(width: 2.wp),

        // Status Filter
        SingleSelectFilterDropdown<MeetingStatus>(
          title: 'Status',
          items: MeetingStatus.values,
          selectedItem: controller.state.selectedStatus,
          getDefaultItem: () => MeetingStatus.SCHEDULED,
          getDisplayValue: (MeetingStatus status) => status.displayName,
          getKeyValue: (MeetingStatus status) => status,
          onSelected: (MeetingStatus status) {
            controller.state.selectedStatus.value = status;
            // controller.applyFilters();
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
            selectedRange: controller.state.selectedDateRange.value,
            onRangeChanged: (range) {
              controller.setDate(range);
            },
          ),
        ),
      ],
    );
  }
}

class DateRangeFilter extends GetView<MeetingController> {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onRangeChanged;

  const DateRangeFilter({
    required this.selectedRange,
    required this.onRangeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDateRangePicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
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
            Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              controller.getDisplayText(),
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey[500]),
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
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              // Selected dates background (your gradient)
              primary: AppColors.gradientDarkStart,

              // Month/weekday titles
              onSurface: Colors.black87,

              // Selected date TEXT (white)
              onPrimary: Colors.white,
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
