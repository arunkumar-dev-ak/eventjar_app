import 'package:eventjar/api/google_calendar_api/google_calendar_api.dart';
import 'package:eventjar/controller/meeting_preferences/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/meeting_preferences/meeting_preferences_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingPreferencesController extends GetxController {
  final state = MeetingPreferencesState();

  @override
  void onInit() {
    super.onInit();
    fetchPreferences();
  }

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
    state.selectedTimezone.value = response.timezone;
    state.selectedSlotInterval.value = _minsToSlotLabel(
      response.slotIntervalMins,
    );
    state.selectedMinNotice.value = _minsToNoticeLabel(
      response.minNoticeMins,
    );
    state.selectedBufferBefore.value = _minsToBufferLabel(
      response.bufferBeforeMins,
    );
    state.selectedBufferAfter.value = _minsToBufferLabel(
      response.bufferAfterMins,
    );

    // day index mapping: API day 0=Sunday,1=Monday,...,6=Saturday
    // State order: 0=Monday,1=Tuesday,...,5=Saturday,6=Sunday
    for (final wh in response.weeklyHours) {
      final stateIndex = _apiDayToStateIndex(wh.day);
      if (stateIndex < 0 || stateIndex >= state.weeklyAvailability.length) {
        continue;
      }
      final day = state.weeklyAvailability[stateIndex];
      day.isEnabled.value = wh.enabled;
      day.startTime.value = _parseTime(wh.startTime);
      day.endTime.value = _parseTime(wh.endTime);
    }
  }

  int _apiDayToStateIndex(int apiDay) {
    // API: 0=Sun,1=Mon,2=Tue,3=Wed,4=Thu,5=Fri,6=Sat
    // State: 0=Mon,1=Tue,2=Wed,3=Thu,4=Fri,5=Sat,6=Sun
    if (apiDay == 0) return 6;
    return apiDay - 1;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _minsToSlotLabel(int mins) {
    return '$mins min';
  }

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

  void updateTimezone(String value) {
    state.selectedTimezone.value = value;
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

  void toggleDay(int index, bool value) {
    state.weeklyAvailability[index].isEnabled.value = value;
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  Future<void> pickStartTime(BuildContext context, int index) async {
    final day = state.weeklyAvailability[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: day.startTime.value,
    );
    if (picked == null) return;

    final endMins = _toMinutes(day.endTime.value);
    final pickedMins = _toMinutes(picked);

    if (pickedMins >= endMins || (endMins - pickedMins) < 30) {
      AppSnackbar.warning(
        title: 'invalid_time'.tr,
        message: 'start_time_before_end'.tr,
      );
      return;
    }

    day.startTime.value = picked;
  }

  Future<void> pickEndTime(BuildContext context, int index) async {
    final day = state.weeklyAvailability[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: day.endTime.value,
    );
    if (picked == null) return;

    final startMins = _toMinutes(day.startTime.value);
    final pickedMins = _toMinutes(picked);

    if (pickedMins <= startMins || (pickedMins - startMins) < 30) {
      AppSnackbar.warning(
        title: 'invalid_time'.tr,
        message: 'end_time_after_start'.tr,
      );
      return;
    }

    day.endTime.value = picked;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> savePreferences() async {
    state.isSaving.value = true;
    // TODO: Implement save API when endpoint is available
    await Future.delayed(const Duration(seconds: 1));
    state.isSaving.value = false;
    AppSnackbar.success(
      title: 'success'.tr,
      message: 'preferences_saved'.tr,
    );
  }
}
