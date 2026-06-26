import 'package:eventjar/model/meeting_preferences/meeting_preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSlot {
  final DateTime start;
  final DateTime end;
  final bool available;
  final String? reason;

  TimeSlot({
    required this.start,
    required this.end,
    required this.available,
    this.reason,
  });
}

class AvailabilityState {
  RxBool isPrefsLoading = true.obs;
  RxBool isSlotsLoading = false.obs;
  RxBool isCalendarConnected = false.obs;
  Rxn<String> availabilityError = Rxn<String>();

  Rxn<MeetingPreferencesResponse> hostPrefs =
      Rxn<MeetingPreferencesResponse>();
  Rxn<MeetingPreferencesResponse> ownPrefs =
      Rxn<MeetingPreferencesResponse>();

  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  Rxn<String> selectedSlotIso = Rxn<String>();

  RxList<FreeBusySlot> busySlots = <FreeBusySlot>[].obs;
  RxList<TimeSlot> timeSlots = <TimeSlot>[].obs;

  final dateTimeController = TextEditingController();

  void reset() {
    selectedDate.value = null;
    selectedSlotIso.value = null;
    timeSlots.clear();
    busySlots.clear();
    hostPrefs.value = null;
    ownPrefs.value = null;
    availabilityError.value = null;
    isPrefsLoading.value = true;
    dateTimeController.clear();
  }

  void dispose() {
    dateTimeController.dispose();
  }
}
