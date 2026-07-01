import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';

enum MeetingButtonType { accept, reschedule, complete }

class ContactListMeetingState {
  // MobileContact from args
  Rx<MobileContact?> mobileContact = Rx<MobileContact?>(null);
  Rx<DateTime> meetingDate = DateTime.now().obs;
  Rx<TimeOfDay> meetingTime = TimeOfDay.now().obs;

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isRescheduling = false.obs;

  // Meetings data
  Rx<ActiveMeeting?> currentMeeting = Rx<ActiveMeeting?>(null);

  // UI states
  RxString appBarTitle = 'contact_meeting'.tr.obs;
  Rx<MeetingButtonType> primaryButtonType = MeetingButtonType.accept.obs;

  // Availability
  final AvailabilityState availability = AvailabilityState();

  // Duration
  final RxInt selectedDuration = 30.obs;
}
