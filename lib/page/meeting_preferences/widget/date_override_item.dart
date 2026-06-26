import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/meeting_preferences/meeting_preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateOverrideItem extends StatelessWidget {
  final DateOverride dateOverride;

  const DateOverrideItem({super.key, required this.dateOverride});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeetingPreferencesController>();
    final isCustom = dateOverride.enabled;

    return Container(
      margin: EdgeInsets.only(bottom: 1.hp),
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.formatOverrideDate(dateOverride.date),
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    if (dateOverride.label != null && dateOverride.label!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 0.3.hp),
                        child: Text(
                          dateOverride.label!,
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildModeChip(
                context,
                label: 'unavailable'.tr,
                isActive: !isCustom,
                onTap: () => controller.toggleOverrideMode(dateOverride.date, false),
              ),
              SizedBox(width: 1.5.wp),
              _buildModeChip(
                context,
                label: 'custom_hours'.tr,
                isActive: isCustom,
                onTap: () => controller.toggleOverrideMode(dateOverride.date, true),
              ),
              SizedBox(width: 1.5.wp),
              InkWell(
                onTap: () => controller.removeOverride(dateOverride.date),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: EdgeInsets.all(1.wp),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 5.wp,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ],
          ),
          if (isCustom) ...[
            SizedBox(height: 1.hp),
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    context,
                    dateOverride.startTime ?? '09:00',
                    () => controller.pickOverrideStartTime(context, dateOverride.date),
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
                    dateOverride.endTime ?? '17:00',
                    () => controller.pickOverrideEndTime(context, dateOverride.date),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeChip(
    BuildContext context, {
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF4A6CF7).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? const Color(0xFF4A6CF7)
                : AppColors.border(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 6.5.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? const Color(0xFF4A6CF7)
                : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    String timeStr,
    VoidCallback onTap,
  ) {
    final controller = Get.find<MeetingPreferencesController>();
    final parts = timeStr.split(':');
    final tod = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );

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
              controller.formatTimeOfDay(tod),
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
