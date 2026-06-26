import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/controller/meeting_preferences/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
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
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      controller.formatTimeOfDay(day.startTime.value),
                      () => controller.pickStartTime(context, index),
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
                    child: _buildTimePicker(
                      context,
                      controller.formatTimeOfDay(day.endTime.value),
                      () => controller.pickEndTime(context, index),
                    ),
                  ),
                ],
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

  Widget _buildTimePicker(
    BuildContext context,
    String timeText,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
        decoration: BoxDecoration(
          color: AppColors.inputBg(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 3.5.wp,
              color: AppColors.iconMuted(context),
            ),
            SizedBox(width: 1.5.wp),
            Text(
              timeText,
              style: TextStyle(
                fontSize: 7.5.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
