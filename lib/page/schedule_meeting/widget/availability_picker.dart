import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/controller/schedule_meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AvailabilityPicker extends StatelessWidget {
  const AvailabilityPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleMeetingController>();
    final avail = controller.state.availability;

    return Obx(() {
      if (avail.isPrefsLoading.value) {
        return _buildLoadingRow(context, 'loading_preferences'.tr);
      }

      final error = avail.availabilityError.value;
      if (error != null && avail.hostPrefs.value == null) {
        return _buildErrorBox(context, error);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDurationSelector(context, controller),
          SizedBox(height: 2.hp),
          _buildDatePicker(context, controller),
          SizedBox(height: 2.hp),
          if (error != null) ...[
            _buildWarningBanner(context, error),
            SizedBox(height: 1.hp),
          ],
          _buildSlotSection(context, controller),
          _buildSelectedSummary(context, controller),
        ],
      );
    });
  }

  Widget _buildDurationSelector(
    BuildContext context,
    ScheduleMeetingController controller,
  ) {
    return Obx(() {
      final durations = controller.hostAllowedDurations;
      final selected = controller.state.selectedDuration.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'duration'.tr,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 1.hp),
          Wrap(
            spacing: 2.wp,
            runSpacing: 1.hp,
            children: durations.map((mins) {
              final isActive = selected == mins;
              return GestureDetector(
                onTap: () => controller.selectDuration(mins),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.wp,
                    vertical: 1.hp,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF4A6CF7).withValues(alpha: 0.1)
                        : AppColors.inputBg(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF4A6CF7)
                          : AppColors.border(context),
                    ),
                  ),
                  child: Text(
                    _durationLabel(mins),
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? const Color(0xFF4A6CF7)
                          : AppColors.textSecondary(context),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildDatePicker(
    BuildContext context,
    ScheduleMeetingController controller,
  ) {
    return Obx(() {
      final selectedDate = controller.availability.selectedDate.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'pick_a_date'.tr,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 1.hp),
          InkWell(
            onTap: () => _showDatePicker(context, controller),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 4.wp,
                vertical: 1.8.hp,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 5.wp,
                    color: const Color(0xFF4A6CF7),
                  ),
                  SizedBox(width: 3.wp),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? DateFormat('EEEE, MMMM d, yyyy')
                              .format(selectedDate)
                          : 'select_a_date'.tr,
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        color: selectedDate != null
                            ? AppColors.textPrimary(context)
                            : AppColors.textHint(context),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.iconMuted(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Future<void> _showDatePicker(
    BuildContext context,
    ScheduleMeetingController controller,
  ) async {
    final now = DateTime.now();
    final maxDate = controller.maxBookingDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: controller.availability.selectedDate.value ?? now,
      firstDate: now,
      lastDate: maxDate,
      selectableDayPredicate: (date) => controller.isDayAvailable(date),
    );

    if (picked != null) {
      controller.onDateSelected(picked);
    }
  }

  Widget _buildSlotSection(
    BuildContext context,
    ScheduleMeetingController controller,
  ) {
    return Obx(() {
      final avail = controller.availability;
      if (avail.selectedDate.value == null) return const SizedBox.shrink();

      if (avail.isSlotsLoading.value) {
        return _buildLoadingRow(context, 'loading_free_slots'.tr);
      }

      final slots = avail.timeSlots;

      if (slots.isEmpty) {
        return _buildNoSlotsBox(context);
      }

      final availableCount = slots.where((s) => s.available).length;
      final busyCount = slots.length - availableCount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 3.5.wp,
                    color: AppColors.textSecondary(context),
                  ),
                  SizedBox(width: 1.wp),
                  Text(
                    availableCount > 0
                        ? '$availableCount ${'available'.tr}, $busyCount ${'busy_label'.tr}'
                        : '${'all_slots_busy'.tr} (${slots.length})',
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
              if (avail.isCalendarConnected.value)
                Text(
                  'calendar_synced'.tr,
                  style: TextStyle(
                    fontSize: 6.sp,
                    color: Colors.green.shade600,
                  ),
                )
              else
                Text(
                  'calendar_not_connected'.tr,
                  style: TextStyle(
                    fontSize: 6.sp,
                    color: Colors.orange.shade600,
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.hp),
          _TimeSlotGrid(slots: slots, controller: controller),
          if (availableCount == 0)
            Padding(
              padding: EdgeInsets.only(top: 1.hp),
              child: Text(
                'try_another_day'.tr,
                style: TextStyle(
                  fontSize: 7.sp,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSelectedSummary(
    BuildContext context,
    ScheduleMeetingController controller,
  ) {
    return Obx(() {
      final avail = controller.availability;
      final slotIso = avail.selectedSlotIso.value;
      final selectedDate = avail.selectedDate.value;
      if (slotIso == null || selectedDate == null) {
        return const SizedBox.shrink();
      }

      final slotUtc = DateTime.parse(slotIso).toUtc();
      final durationMins = controller.selectedDurationMins;
      final slotStart = slotUtc.add(controller.viewerDisplayOffset);
      final slotEnd = slotStart.add(Duration(minutes: durationMins));

      return Padding(
        padding: EdgeInsets.only(top: 2.hp),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                style: TextStyle(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 0.5.hp),
              Text(
                '${DateFormat('h:mm a').format(slotStart)} – ${DateFormat('h:mm a').format(slotEnd)} ($durationMins min)',
                style: TextStyle(
                  fontSize: 7.5.sp,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Helpers ──

  String _durationLabel(int mins) {
    if (mins < 60) return '$mins min';
    if (mins == 60) return '1 hour';
    if (mins == 90) return '1.5 hours';
    return '${mins ~/ 60} hours';
  }

  Widget _buildLoadingRow(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.hp),
      child: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textSecondary(context),
            ),
          ),
          SizedBox(width: 2.wp),
          Text(
            message,
            style: TextStyle(
              fontSize: 7.5.sp,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBox(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 5.wp, color: Colors.red.shade600),
          SizedBox(width: 2.wp),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 7.5.sp,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 4.wp,
            color: Colors.orange.shade700,
          ),
          SizedBox(width: 2.wp),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 6.5.sp,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSlotsBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 5.wp,
            color: Colors.orange.shade700,
          ),
          SizedBox(width: 2.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'no_slots_available'.tr,
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  'no_slots_hint'.tr,
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSlotGrid extends StatefulWidget {
  final List<TimeSlot> slots;
  final ScheduleMeetingController controller;

  const _TimeSlotGrid({required this.slots, required this.controller});

  @override
  State<_TimeSlotGrid> createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends State<_TimeSlotGrid> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final available = widget.slots.where((s) => s.available).toList();
    final unavailable = widget.slots.where((s) => !s.available).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 30.hp),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 3,
        radius: const Radius.circular(2),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (available.isNotEmpty) ...[
                _buildSectionLabel(
                  context,
                  '${'available'.tr} (${available.length})',
                  Colors.green.shade700,
                ),
                SizedBox(height: 0.8.hp),
                Wrap(
                  spacing: 2.wp,
                  runSpacing: 1.hp,
                  children: available.map((slot) {
                    final iso = slot.start.toUtc().toIso8601String();
                    return Obx(() {
                      final isSelected =
                          widget.controller.availability.selectedSlotIso.value == iso;
                      return GestureDetector(
                        onTap: () => widget.controller.onSlotSelected(iso),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.wp,
                            vertical: 1.hp,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green.shade600
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green.shade600
                                  : Colors.green.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected)
                                Padding(
                                  padding: EdgeInsets.only(right: 1.5.wp),
                                  child: Icon(
                                    Icons.check,
                                    size: 4.wp,
                                    color: Colors.white,
                                  ),
                                ),
                              Text(
                                widget.controller.formatSlotLabel(slot),
                                style: TextStyle(
                                  fontSize: 8.6.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ],
              if (unavailable.isNotEmpty) ...[
                SizedBox(height: 1.5.hp),
                _buildSectionLabel(
                  context,
                  '${'unavailable'.tr} (${unavailable.length})',
                  AppColors.textHint(context),
                ),
                SizedBox(height: 0.8.hp),
                Wrap(
                  spacing: 2.wp,
                  runSpacing: 1.hp,
                  children: unavailable.map((slot) {
                    final isBusy = slot.reason == 'busy';
                    final bgColor = isBusy
                        ? Colors.red.shade50
                        : Colors.grey.shade100;
                    final borderColor = isBusy
                        ? Colors.red.shade100
                        : Colors.grey.shade300;
                    final textColor = isBusy
                        ? Colors.red.shade300
                        : Colors.grey.shade400;

                    return Tooltip(
                      message: _reasonText(slot.reason),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.wp,
                          vertical: 1.hp,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          widget.controller.formatSlotLabel(slot),
                          style: TextStyle(
                            fontSize: 8.6.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 7.5.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  String _reasonText(String? reason) {
    switch (reason) {
      case 'busy':
        return 'slot_busy'.tr;
      case 'notice':
        return 'slot_notice'.tr;
      case 'past':
        return 'slot_past'.tr;
      default:
        return 'unavailable'.tr;
    }
  }
}
