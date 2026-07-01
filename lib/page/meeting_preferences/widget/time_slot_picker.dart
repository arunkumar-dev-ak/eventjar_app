import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSlotPicker extends StatelessWidget {
  final TimeOfDay currentValue;
  final TimeOfDay? after;
  final TimeOfDay? before;
  final ValueChanged<TimeOfDay> onSelected;

  const TimeSlotPicker({
    super.key,
    required this.currentValue,
    this.after,
    this.before,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeetingPreferencesController>();

    return InkWell(
      onTap: () => _showPicker(context, controller),
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
              controller.formatTimeOfDay(currentValue),
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

  void _showPicker(
    BuildContext context,
    MeetingPreferencesController controller,
  ) {
    final slots = controller.getTimeSlots(after: after, before: before);
    if (slots.isEmpty) return;

    final currentMins = currentValue.hour * 60 + currentValue.minute;
    final initialIndex = slots.indexWhere(
      (t) => t.hour * 60 + t.minute == currentMins,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final scrollController = ScrollController(
          initialScrollOffset: (initialIndex > 0 ? initialIndex : 0) * 48.0,
        );
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          maxChildSize: 0.7,
          minChildSize: 0.3,
          expand: false,
          builder: (context, _) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'select_time'.tr,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: slots.length,
                    itemExtent: 48,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final isSelected =
                          slot.hour * 60 + slot.minute == currentMins;
                      return ListTile(
                        dense: true,
                        title: Text(
                          controller.formatTimeOfDay(slot),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF4A6CF7)
                                : AppColors.textPrimary(context),
                          ),
                        ),
                        tileColor: isSelected
                            ? const Color(0xFF4A6CF7).withValues(alpha: 0.1)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          onSelected(slot);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
