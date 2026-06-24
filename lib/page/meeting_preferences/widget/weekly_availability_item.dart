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

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.hp),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Switch(
                value: enabled,
                onChanged: (val) => controller.toggleDay(index, val),
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF4A6CF7),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.border(context),
              ),
            ),
            SizedBox(width: 2.wp),
            SizedBox(
              width: 22.wp,
              child: Text(
                day.day,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                  color: enabled
                      ? AppColors.textPrimary(context)
                      : AppColors.textHint(context),
                ),
              ),
            ),
            if (enabled) ...[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimePicker(
                      context,
                      controller.formatTimeOfDay(day.startTime.value),
                      () => controller.pickStartTime(context, index),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.wp),
                      child: Text(
                        'to',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                    _buildTimePicker(
                      context,
                      controller.formatTimeOfDay(day.endTime.value),
                      () => controller.pickEndTime(context, index),
                    ),
                  ],
                ),
              ),
            ] else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.wp),
                  child: Text(
                    'Unavailable',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.textHint(context),
                      fontStyle: FontStyle.italic,
                    ),
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
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 1.hp),
        decoration: BoxDecoration(
          color: AppColors.inputBg(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeText,
              style: TextStyle(
                fontSize: 7.5.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary(context),
              ),
            ),
            SizedBox(width: 1.wp),
            Icon(
              Icons.access_time_rounded,
              size: 3.5.wp,
              color: AppColors.iconMuted(context),
            ),
          ],
        ),
      ),
    );
  }
}
