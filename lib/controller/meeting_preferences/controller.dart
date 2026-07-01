import 'package:eventjar/api/google_calendar_api/google_calendar_api.dart';
import 'package:eventjar/controller/meeting_preferences/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/meeting_preferences/meeting_preferences_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MeetingPreferencesController extends GetxController {
  final state = MeetingPreferencesState();

  @override
  void onInit() {
    super.onInit();
    _ensureDeviceTimezone();
    fetchPreferences();
  }

  // ═══════════════════════════════════════════════════════════════
  //  Timezone Detection
  // ═══════════════════════════════════════════════════════════════

  Future<void> _ensureDeviceTimezone() async {
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final detectedTz = tzInfo.identifier;
      if (detectedTz.isNotEmpty && !state.timezones.contains(detectedTz)) {
        state.timezones.insert(0, detectedTz);
      }
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════════════
  //  Fetch Preferences (API)
  // ═══════════════════════════════════════════════════════════════

  Future<void> fetchPreferences() async {
    state.isLoading.value = true;
    try {
      final response = await GoogleCalendarApi.getMeetingPreferences();
      _applyResponse(response);
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: 'failed_load_preferences'.tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          Get.toNamed(RouteName.signInPage);
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  void _applyResponse(MeetingPreferencesResponse response) {
    _applyGeneralSettings(response);
    _applyWeeklyHours(response);
    _applyDateOverrides(response);
  }

  void _applyGeneralSettings(MeetingPreferencesResponse response) {
    state.selectedTimezone.value = response.timezone;
    state.selectedTimezoneRxn.value = response.timezone;
    state.selectedSlotInterval.value = _minsToSlotLabel(response.slotIntervalMins);
    state.selectedMinNotice.value = _minsToNoticeLabel(response.minNoticeMins);
    state.selectedBufferBefore.value = _minsToBufferLabel(response.bufferBeforeMins);
    state.selectedBufferAfter.value = _minsToBufferLabel(response.bufferAfterMins);
    state.selectedMaxAdvanceDays.value = response.maxAdvanceDays;
    state.selectedAllowedDurations.value = List<int>.from(response.allowedDurations);
    state.videoProvider.value = response.videoProvider;
    state.customVideoUrl.value = response.customVideoUrl;
  }

  void _applyWeeklyHours(MeetingPreferencesResponse response) {
    for (final wh in response.weeklyHours) {
      final stateIndex = _apiDayToStateIndex(wh.day);
      if (stateIndex < 0 || stateIndex >= state.weeklyAvailability.length) continue;

      final day = state.weeklyAvailability[stateIndex];
      day.isEnabled.value = wh.enabled;

      day.ranges.clear();
      for (final range in wh.ranges) {
        day.ranges.add(DayTimeRange(
          start: _parseTime(range.startTime),
          end: _parseTime(range.endTime),
        ));
      }
      if (day.ranges.isEmpty) {
        day.ranges.add(DayTimeRange(
          start: _parseTime(wh.startTime),
          end: _parseTime(wh.endTime),
        ));
      }
    }
  }

  void _applyDateOverrides(MeetingPreferencesResponse response) {
    state.dateOverrides.value = List<DateOverride>.from(response.dateOverrides);
  }

  // ═══════════════════════════════════════════════════════════════
  //  General Settings
  // ═══════════════════════════════════════════════════════════════

  void updateTimezone(String value) {
    state.selectedTimezone.value = value;
    state.selectedTimezoneRxn.value = value;
  }

  void updateSlotInterval(String value) {
    state.selectedSlotInterval.value = value;
  }

  void updateMinNotice(String value) {
    state.selectedMinNotice.value = value;
  }

  void updateBufferBefore(String value) {
    state.selectedBufferBefore.value = value;
  }

  void updateBufferAfter(String value) {
    state.selectedBufferAfter.value = value;
  }

  void updateMaxAdvanceDays(int value) {
    state.selectedMaxAdvanceDays.value = value;
  }

  void toggleDuration(int mins) {
    final current = List<int>.from(state.selectedAllowedDurations);
    if (current.contains(mins)) {
      if (current.length <= 1) return;
      current.remove(mins);
    } else {
      current.add(mins);
      current.sort();
    }
    state.selectedAllowedDurations.value = current;
  }

  // ═══════════════════════════════════════════════════════════════
  //  Weekly Hours
  // ═══════════════════════════════════════════════════════════════

  void toggleDay(int index, bool value) {
    final day = state.weeklyAvailability[index];
    day.isEnabled.value = value;
    if (value && day.ranges.isEmpty) {
      day.ranges.add(DayTimeRange(
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 18, minute: 0),
      ));
    }
  }

  void addRange(int dayIndex) {
    final day = state.weeklyAvailability[dayIndex];
    final lastRange = day.ranges.isNotEmpty ? day.ranges.last : null;
    final startTime = lastRange != null
        ? _nextTime15After(lastRange.endTime.value)
        : const TimeOfDay(hour: 9, minute: 0);
    final endTime = _nextTime15After(startTime);

    if (_toMinutes(startTime) >= 24 * 60 - 15) return;

    day.ranges.add(DayTimeRange(start: startTime, end: endTime));
  }

  void removeRange(int dayIndex, int rangeIndex) {
    final day = state.weeklyAvailability[dayIndex];
    if (day.ranges.length > 1) {
      day.ranges.removeAt(rangeIndex);
    }
  }

  void updateRangeStartTime(int dayIndex, int rangeIndex, TimeOfDay picked) {
    final day = state.weeklyAvailability[dayIndex];
    if (rangeIndex >= day.ranges.length) return;
    final range = day.ranges[rangeIndex];

    if (_toMinutes(picked) >= _toMinutes(range.endTime.value)) {
      range.endTime.value = _nextTime15After(picked);
    }

    range.startTime.value = picked;
  }

  void updateRangeEndTime(int dayIndex, int rangeIndex, TimeOfDay picked) {
    final day = state.weeklyAvailability[dayIndex];
    if (rangeIndex >= day.ranges.length) return;
    final range = day.ranges[rangeIndex];

    if (_toMinutes(picked) <= _toMinutes(range.startTime.value)) {
      AppToast.warning('end_time_after_start'.tr);
      return;
    }

    range.endTime.value = picked;
  }

  Set<int> getDisabledWeekdays() {
    final disabled = <int>{};
    for (int i = 0; i < state.weeklyAvailability.length; i++) {
      if (!state.weeklyAvailability[i].isEnabled.value) {
        disabled.add(i == 6 ? 7 : i + 1);
      }
    }
    return disabled;
  }

  // ═══════════════════════════════════════════════════════════════
  //  Date Overrides
  // ═══════════════════════════════════════════════════════════════

  void addDateOverrides(List<DateTime> dates) {
    final existingDates = state.dateOverrides.map((o) => o.date).toSet();
    final additions = dates
        .map((d) => DateFormat('yyyy-MM-dd').format(d))
        .where((d) => !existingDates.contains(d))
        .map((date) => DateOverride(date: date, enabled: false))
        .toList();
    if (additions.isEmpty) return;
    state.dateOverrides.addAll(additions);
    _sortOverrides();
  }

  void updateOverride(String date, {bool? enabled, String? startTime, String? endTime, String? label}) {
    final idx = state.dateOverrides.indexWhere((o) => o.date == date);
    if (idx < 0) return;
    final old = state.dateOverrides[idx];
    state.dateOverrides[idx] = old.copyWith(
      enabled: enabled ?? old.enabled,
      startTime: startTime ?? old.startTime,
      endTime: endTime ?? old.endTime,
      label: label ?? old.label,
    );
  }

  void toggleOverrideMode(String date, bool customHours) {
    final idx = state.dateOverrides.indexWhere((o) => o.date == date);
    if (idx < 0) return;
    final old = state.dateOverrides[idx];
    state.dateOverrides[idx] = DateOverride(
      date: old.date,
      enabled: customHours,
      startTime: customHours ? (old.startTime ?? '09:00') : old.startTime,
      endTime: customHours ? (old.endTime ?? '17:00') : old.endTime,
      label: old.label,
    );
  }

  void removeOverride(String date) {
    state.dateOverrides.removeWhere((o) => o.date == date);
  }

  void addHolidaysAsOverrides(List<Holiday> holidays) {
    final existingDates = state.dateOverrides.map((o) => o.date).toSet();
    final additions = holidays
        .where((h) => !existingDates.contains(h.date))
        .map((h) => DateOverride(date: h.date, enabled: false, label: h.name))
        .toList();
    if (additions.isEmpty) return;
    state.dateOverrides.addAll(additions);
    _sortOverrides();
  }

  void _sortOverrides() {
    state.dateOverrides.sort((a, b) => a.date.compareTo(b.date));
  }

  String formatOverrideDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, MMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> pickOverrideStartTime(BuildContext context, String date) async {
    final idx = state.dateOverrides.indexWhere((o) => o.date == date);
    if (idx < 0) return;
    final override = state.dateOverrides[idx];
    final initial = _parseTime(override.startTime ?? '09:00');
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    final endTime = _parseTime(override.endTime ?? '17:00');
    if (_toMinutes(picked) >= _toMinutes(endTime)) {
      AppToast.warning('start_time_before_end'.tr);
      return;
    }

    final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    updateOverride(date, startTime: timeStr);
  }

  Future<void> pickOverrideEndTime(BuildContext context, String date) async {
    final idx = state.dateOverrides.indexWhere((o) => o.date == date);
    if (idx < 0) return;
    final override = state.dateOverrides[idx];
    final initial = _parseTime(override.endTime ?? '17:00');
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    final startTime = _parseTime(override.startTime ?? '09:00');
    if (_toMinutes(picked) <= _toMinutes(startTime)) {
      AppToast.warning('end_time_after_start'.tr);
      return;
    }

    final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    updateOverride(date, endTime: timeStr);
  }

  // ═══════════════════════════════════════════════════════════════
  //  Holiday Import
  // ═══════════════════════════════════════════════════════════════

  void resetHolidayDialogState() {
    state.holidays.clear();
    state.selectedHolidayDates.clear();
    state.isLoadingHolidays.value = false;
  }

  Future<void> fetchHolidayCountries() async {
    if (state.holidayCountries.isNotEmpty) return;
    state.isLoadingCountries.value = true;
    try {
      final countries = await GoogleCalendarApi.getHolidayCountries();
      state.holidayCountries.value = countries;
      if (countries.isNotEmpty && state.selectedCountryCode.value.isEmpty) {
        state.selectedCountryCode.value = countries.first.code;
      }
    } catch (_) {
      AppToast.warning('failed_load_countries'.tr);
    } finally {
      state.isLoadingCountries.value = false;
    }
  }

  Future<void> fetchHolidays() async {
    if (state.selectedCountryCode.value.isEmpty) return;
    state.isLoadingHolidays.value = true;
    state.selectedHolidayDates.clear();
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final holidays = await GoogleCalendarApi.getHolidays(
        state.selectedCountryCode.value,
        state.selectedHolidayYear.value,
      );
      state.holidays.value = holidays.where((h) => h.date.compareTo(today) >= 0).toList();
    } catch (_) {
      state.holidays.clear();
    } finally {
      state.isLoadingHolidays.value = false;
    }
  }

  void toggleHolidaySelection(String date) {
    if (state.selectedHolidayDates.contains(date)) {
      state.selectedHolidayDates.remove(date);
    } else {
      state.selectedHolidayDates.add(date);
    }
  }

  void selectAllHolidays() {
    final existingDates = state.dateOverrides.map((o) => o.date).toSet();
    final selectable = state.holidays
        .where((h) => !existingDates.contains(h.date))
        .map((h) => h.date)
        .toSet();
    if (selectable.length == state.selectedHolidayDates.length &&
        selectable.every((d) => state.selectedHolidayDates.contains(d))) {
      state.selectedHolidayDates.clear();
    } else {
      state.selectedHolidayDates.clear();
      state.selectedHolidayDates.addAll(selectable);
    }
  }

  void importSelectedHolidays() {
    final selected = state.holidays
        .where((h) => state.selectedHolidayDates.contains(h.date))
        .toList();
    addHolidaysAsOverrides(selected);
    state.selectedHolidayDates.clear();
  }

  // ═══════════════════════════════════════════════════════════════
  //  Build Payload & Save
  // ═══════════════════════════════════════════════════════════════

  Map<String, dynamic> _buildGeneralPayload() {
    return {
      'timezone': state.selectedTimezone.value,
      'slot_interval_mins': _slotLabelToMins(state.selectedSlotInterval.value),
      'buffer_before_mins': _bufferLabelToMins(state.selectedBufferBefore.value),
      'buffer_after_mins': _bufferLabelToMins(state.selectedBufferAfter.value),
      'min_notice_mins': _noticeLabelToMins(state.selectedMinNotice.value),
      'max_advance_days': state.selectedMaxAdvanceDays.value,
      'allowed_durations': state.selectedAllowedDurations.toList(),
      'video_provider': state.videoProvider.value,
      if (state.customVideoUrl.value != null)
        'custom_video_url': state.customVideoUrl.value,
    };
  }

  List<Map<String, dynamic>> _buildWeeklyHoursPayload() {
    final weeklyHours = <Map<String, dynamic>>[];
    for (int i = 0; i < state.weeklyAvailability.length; i++) {
      final day = state.weeklyAvailability[i];
      final ranges = day.ranges.map((r) {
        final start = r.startTime.value;
        final end = r.endTime.value;
        return {
          'startTime': '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
          'endTime': '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
        };
      }).toList();

      final firstStart = day.ranges.isNotEmpty ? day.ranges.first.startTime.value : const TimeOfDay(hour: 9, minute: 0);
      final firstEnd = day.ranges.isNotEmpty ? day.ranges.first.endTime.value : const TimeOfDay(hour: 18, minute: 0);

      weeklyHours.add({
        'day': _stateIndexToApiDay(i),
        'enabled': day.isEnabled.value,
        'ranges': ranges,
        'startTime': '${firstStart.hour.toString().padLeft(2, '0')}:${firstStart.minute.toString().padLeft(2, '0')}',
        'endTime': '${firstEnd.hour.toString().padLeft(2, '0')}:${firstEnd.minute.toString().padLeft(2, '0')}',
      });
    }
    return weeklyHours;
  }

  List<Map<String, dynamic>> _buildDateOverridesPayload() {
    return state.dateOverrides.map((o) => o.toJson()).toList();
  }

  Map<String, dynamic> _buildPayload() {
    return {
      ..._buildGeneralPayload(),
      'weekly_hours': _buildWeeklyHoursPayload(),
      'date_overrides': _buildDateOverridesPayload(),
    };
  }

  Future<void> savePreferences() async {
    state.isSaving.value = true;
    try {
      final payload = _buildPayload();
      final success = await GoogleCalendarApi.updateMeetingPreferences(payload);
      if (success) {
        AppSnackbar.success(
          title: 'success'.tr,
          message: 'preferences_saved'.tr,
        );
        Navigator.pop(Get.context!);
      } else {
        AppSnackbar.error(title: 'error'.tr, message: 'save_failed'.tr);
      }
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: 'save_failed'.tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          Get.toNamed(RouteName.signInPage);
        },
      );
    } finally {
      state.isSaving.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  Helpers
  // ═══════════════════════════════════════════════════════════════

  int _apiDayToStateIndex(int apiDay) {
    if (apiDay == 0) return 6;
    return apiDay - 1;
  }

  int _stateIndexToApiDay(int stateIndex) {
    if (stateIndex == 6) return 0;
    return stateIndex + 1;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  TimeOfDay _nextTime15After(TimeOfDay time) {
    final mins = _toMinutes(time) + 15;
    if (mins >= 24 * 60) return const TimeOfDay(hour: 23, minute: 45);
    return TimeOfDay(hour: mins ~/ 60, minute: mins % 60);
  }

  List<TimeOfDay> _generate15MinSlots({TimeOfDay? after, TimeOfDay? before}) {
    final slots = <TimeOfDay>[];
    for (int h = 0; h < 24; h++) {
      for (int m = 0; m < 60; m += 15) {
        final t = TimeOfDay(hour: h, minute: m);
        final mins = _toMinutes(t);
        if (after != null && mins <= _toMinutes(after)) continue;
        if (before != null && mins >= _toMinutes(before)) continue;
        slots.add(t);
      }
    }
    return slots;
  }

  List<TimeOfDay> getTimeSlots({TimeOfDay? after, TimeOfDay? before}) {
    return _generate15MinSlots(after: after, before: before);
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _minsToSlotLabel(int mins) => '$mins min';

  String _minsToNoticeLabel(int mins) {
    if (mins == 0) return 'No minimum';
    if (mins >= 1440) return '1 day';
    if (mins >= 60) {
      final hours = mins ~/ 60;
      return hours == 1 ? '1 hour' : '$hours hours';
    }
    return '$mins min';
  }

  String _minsToBufferLabel(int mins) {
    if (mins == 0) return 'None';
    return '$mins min';
  }

  int _slotLabelToMins(String label) {
    if (label == 'No minimum') return 0;
    return int.tryParse(label.replaceAll(' min', '')) ?? 30;
  }

  int _noticeLabelToMins(String label) {
    switch (label) {
      case 'No minimum':
        return 0;
      case '30 min':
        return 30;
      case '1 hour':
        return 60;
      case '2 hours':
        return 120;
      case '4 hours':
        return 240;
      case '1 day':
        return 1440;
      default:
        return 60;
    }
  }

  int _bufferLabelToMins(String label) {
    if (label == 'None') return 0;
    return int.tryParse(label.replaceAll(' min', '')) ?? 0;
  }
}
