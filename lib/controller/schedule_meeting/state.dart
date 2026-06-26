import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/model/contact/config_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleMeetingState {
  final RxBool isLoading = false.obs;
  RxBool configLoading = false.obs;
  Rxn<ConfigStatusResponse> configStatus = Rxn();

  Rx<MobileContact?> contact = Rx<MobileContact?>(null);

  var meetingDate = DateTime.now().obs;
  var meetingTime = TimeOfDay.now().obs;
  var meetingEmailChecked = true.obs;
  var meetingWhatsappChecked = false.obs;

  // Duration
  final RxInt selectedDuration = 30.obs;

  // Availability
  final AvailabilityState availability = AvailabilityState();
}
