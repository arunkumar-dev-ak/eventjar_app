import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/meta/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulerState {
  RxBool isLoading = false.obs;

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
    {'key': '15', 'value': '15 minutes'},
    {'key': '30', 'value': '30 minutes'},
    {'key': '60', 'value': '1 hour'},
    {'key': '90', 'value': '1.5 hours'},
    {'key': '120', 'value': '2 hours'},
  ];

  Rxn<Meta> meta = Rxn<Meta>();
}
