import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RescheduleAvailabilityContent extends StatelessWidget {
  final AvailabilityState availability;
  final int selectedDuration;
  final List<int> allowedDurations;
  final void Function(int) onDurationSelected;
  final void Function(DateTime) onDateSelected;
  final void Function(String) onSlotSelected;
  final String Function(TimeSlot) formatSlotLabel;
  final bool Function(DateTime) isDayAvailable;
  final DateTime maxBookingDate;

  const RescheduleAvailabilityContent({
    super.key,
    required this.availability,
    required this.selectedDuration,
    required this.allowedDurations,
    required this.onDurationSelected,
    required this.onDateSelected,
    required this.onSlotSelected,
    required this.formatSlotLabel,
    required this.isDayAvailable,
    required this.maxBookingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (availability.isPrefsLoading.value) {
        return _buildLoadingRow(context, 'loading_preferences'.tr);
      }

      final error = availability.availabilityError.value;
      if (error != null && availability.hostPrefs.value == null) {
        return _buildErrorBox(context, error);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (allowedDurations.length > 1) ...[
            _buildDurationSelector(context),
            SizedBox(height: 2.hp),
          ],
          if (availability.isDatesLoading.value)
            _buildLoadingRow(context, 'loading_available_dates'.tr)
          else
            _buildDatePicker(context),
          SizedBox(height: 2.hp),
          if (error != null) ...[
            _buildWarningBanner(context, error),
            SizedBox(height: 1.hp),
          ],
          _buildSlotSection(context),
        ],
      );
    });
  }

  Widget _buildDurationSelector(BuildContext context) {
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
          children: allowedDurations.map((mins) {
            final isActive = selectedDuration == mins;
            return GestureDetector(
              onTap: () => onDurationSelected(mins),
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
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() {
      final selectedDate = availability.selectedDate.value;
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
            onTap: () => _showDatePicker(context),
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
                          ? DateFormat('EEEE, MMMM d, yyyy').format(selectedDate)
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

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: availability.selectedDate.value ?? now,
      firstDate: now,
      lastDate: maxBookingDate,
      selectableDayPredicate: isDayAvailable,
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Widget _buildSlotSection(BuildContext context) {
    return Obx(() {
      if (availability.selectedDate.value == null) return const SizedBox.shrink();

      if (availability.isSlotsLoading.value) {
        return _buildLoadingRow(context, 'loading_free_slots'.tr);
      }

      final slots = availability.timeSlots;
      if (slots.isEmpty) return _buildNoSlotsBox(context);

      final available = slots.where((s) => s.available).toList();
      final unavailable = slots.where((s) => !s.available).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                available.isNotEmpty
                    ? '${available.length} ${'available'.tr}, ${unavailable.length} ${'busy_label'.tr}'
                    : '${'all_slots_busy'.tr} (${slots.length})',
                style: TextStyle(
                  fontSize: 7.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.hp),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 25.hp),
            child: SingleChildScrollView(
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
                              availability.selectedSlotIso.value == iso;
                          return GestureDetector(
                            onTap: () => onSlotSelected(iso),
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
                                    formatSlotLabel(slot),
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
                        return Tooltip(
                          message: _reasonText(slot.reason),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.wp,
                              vertical: 1.hp,
                            ),
                            decoration: BoxDecoration(
                              color: isBusy ? Colors.red.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isBusy ? Colors.red.shade100 : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              formatSlotLabel(slot),
                              style: TextStyle(
                                fontSize: 8.6.sp,
                                fontWeight: FontWeight.w500,
                                color: isBusy ? Colors.red.shade300 : Colors.grey.shade400,
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
          if (available.isEmpty)
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
