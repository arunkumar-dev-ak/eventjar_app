import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingState {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxInt selectedTab = 0.obs;
  RxMap<String, bool> buttonLoading = <String, bool>{}.obs;

  Rxn<MeetingStatus> selectedStatus = Rxn();

  final Rx<DateTimeRange> selectedDateRange = Rx<DateTimeRange>(
    DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 7)),
    ),
  );

  List<DateTimeRange> get quickDateRanges => [
    DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    ),
    DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    ),
    DateTimeRange(start: DateTime(2026, 1, 1), end: DateTime.now()),
  ];

  RxList<ContactMeeting> meetings = <ContactMeeting>[].obs;
}
