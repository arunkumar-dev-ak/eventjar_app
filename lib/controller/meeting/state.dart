import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/network-meeting/network_meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingState {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxInt selectedTab = 0.obs;
  RxMap<String, bool> buttonLoading = <String, bool>{}.obs;

  // One-on-One tab state
  RxBool isOneOnOneLoading = false.obs;
  RxBool isOneOnOneLoadingMore = false.obs;
  RxList<NetworkMeeting> oneOnOneMeetings = <NetworkMeeting>[].obs;
  Rxn<String> oneOnOneNextCursor = Rxn<String>();
  RxBool oneOnOneHasNextPage = false.obs;

  // One-on-One tab date selection
  Rx<DateTime> oneOnOneSelectedDate = DateTime.now().obs;
  RxInt oneOnOneDisplayedMonth = DateTime.now().month.obs;
  RxInt oneOnOneDisplayedYear = DateTime.now().year.obs;

  // Qualified Contact tab date selection
  Rx<DateTime> qualifiedSelectedDate = DateTime.now().obs;
  RxInt qualifiedDisplayedMonth = DateTime.now().month.obs;
  RxInt qualifiedDisplayedYear = DateTime.now().year.obs;

  RxList<ContactMeeting> meetings = <ContactMeeting>[].obs;

  // Reschedule dialog state
  RxBool isRescheduling = false.obs;
  Rx<DateTime> rescheduleMeetingDate = DateTime.now().obs;
  Rx<TimeOfDay> rescheduleMeetingTime = TimeOfDay.now().obs;
}
