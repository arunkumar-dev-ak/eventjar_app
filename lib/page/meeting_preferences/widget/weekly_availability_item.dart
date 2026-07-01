import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/controller/meeting_preferences/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting_preferences/widget/time_slot_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyAvailabilityItem extends StatelessWidget {
  final int index;
  final DayAvailability day;

  const WeeklyAvailabilityItem({
    super.key,
    required this.index,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeetingPreferencesController>();

    return Obx(() {
      final enabled = day.isEnabled.value;

      return Container(
        margin: EdgeInsets.only(bottom: 1.hp),
        padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.2.hp),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.cardBg(context)
              : AppColors.inputBg(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : AppColors.border(context),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day.day,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? AppColors.textPrimary(context)
                        : AppColors.textHint(context),
                  ),
                ),
                SizedBox(
                  height: 28,
                  child: Switch(
                    value: enabled,
                    onChanged: (val) => controller.toggleDay(index, val),
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF4A6CF7),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.border(context),
                  ),
                ),
              ],
            ),
            if (enabled) ...[
              SizedBox(height: 0.8.hp),
              ...List.generate(day.ranges.length, (rangeIndex) {
                final range = day.ranges[rangeIndex];
                final prevEnd = rangeIndex > 0
                    ? day.ranges[rangeIndex - 1].endTime.value
                    : null;
                final nextStart = rangeIndex < day.ranges.length - 1
                    ? day.ranges[rangeIndex + 1].startTime.value
                    : null;

                return Obx(() => Padding(
                  padding: EdgeInsets.only(
                    bottom: rangeIndex < day.ranges.length - 1 ? 0.8.hp : 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TimeSlotPicker(
                          currentValue: range.startTime.value,
                          after: prevEnd,
                          before: nextStart,
                          onSelected: (picked) =>
                              controller.updateRangeStartTime(index, rangeIndex, picked),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.wp),
                        child: Text(
                          'to',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TimeSlotPicker(
                          currentValue: range.endTime.value,
                          after: range.startTime.value,
                          before: nextStart,
                          onSelected: (picked) =>
                              controller.updateRangeEndTime(index, rangeIndex, picked),
                        ),
                      ),
                      if (day.ranges.length > 1)
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            onPressed: () => controller.removeRange(index, rangeIndex),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.textHint(context),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 32),
                    ],
                  ),
                ));
              }),
              SizedBox(height: 0.5.hp),
              GestureDetector(
                onTap: () => controller.addRange(index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 14,
                      color: Color(0xFF4A6CF7),
                    ),
                    SizedBox(width: 1.wp),
                    Text(
                      'add_hours'.tr,
                      style: TextStyle(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4A6CF7),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              Padding(
                padding: EdgeInsets.only(top: 0.3.hp),
                child: Text(
                  'unavailable'.tr,
                  style: TextStyle(
                    fontSize: 7.5.sp,
                    color: AppColors.textHint(context),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
