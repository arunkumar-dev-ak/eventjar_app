import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/meta/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulerState {
  RxBool isLoading = false.obs;

  Rxn<ContactMeeting> selectedMeeting = Rxn<ContactMeeting>();
  Rxn<MeetingStatusForReschedule> selectedStatus = Rxn();

  // Form fields
  final contactController = TextEditingController();
  final notesController = TextEditingController();
  final dateTimeController = TextEditingController();

  RxList<MobileContact> contacts = <MobileContact>[].obs;
  Rxn<MobileContact> selectedContact = Rxn<MobileContact>();
  RxBool isContactDropdownLoading = false.obs;
  RxBool isContactDropdownLoadMoreLoading = false.obs;

  Rx<DateTime?> scheduledAt = Rx<DateTime?>(null);

  final Rxn<Map<String, String>> selectedDurationMap =
      Rxn<Map<String, String>>();
  final List<Map<String, String>> durations = [
    {'key': '15', 'value': 'fifteen_minutes'},
    {'key': '30', 'value': 'thirty_minutes'},
    {'key': '60', 'value': 'one_hour'},
    {'key': '90', 'value': 'one_half_hour'},
    {'key': '120', 'value': 'two_hour'},
  ];

  Rxn<Meta> meta = Rxn<Meta>();
}
