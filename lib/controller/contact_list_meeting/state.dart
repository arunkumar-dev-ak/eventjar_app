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
  // RxList<NetworkMeetingResponseModel> meetings =
  //     <NetworkMeetingResponseModel>[].obs;
  Rx<ActiveMeeting?> currentMeeting = Rx<ActiveMeeting?>(null);

  // UI states
  RxString appBarTitle = 'Contact Meeting'.obs;
  Rx<MeetingButtonType> primaryButtonType = MeetingButtonType.accept.obs;
}
