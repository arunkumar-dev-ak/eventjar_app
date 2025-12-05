import 'package:eventjar/controller/schedule_meeting/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleMeetingController extends GetxController {
  var appBarTitle = "Schedule Meeting";
  final state = ScheduleMeetingState();

  final formKey = GlobalKey<FormState>();
  //meeting form
  TextEditingController meetingDateController = TextEditingController();
  TextEditingController meetingTimeController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    state.contact.value = args;
    super.onInit();
    updateMeetingDate(DateTime.now());
    updateMeetingTime(TimeOfDay.now());
  }

  // Update date/time display
  void updateMeetingDate(DateTime dateTime) {
    state.meetingDate.value = dateTime;
    meetingDateController.text =
        '${dateTime.day.toString().padLeft(2, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  }

  void updateMeetingTime(TimeOfDay time) {
    state.meetingTime.value = time;
    meetingTimeController.text = time.format(Get.context!);
  }

  // Pick date
  Future<void> pickMeetingDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: state.meetingDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      updateMeetingDate(picked);
    }
  }

  // Pick time
  Future<void> pickMeetingTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: state.meetingTime.value,
    );
    if (picked != null) {
      updateMeetingTime(picked);
    }
  }

  // Schedule meeting
  Future<void> scheduleMeeting() async {
    // if (meetingFormKey.currentState!.validate()) {
    //   state.isLoading.value = true;

    //   try {
    //     // TODO: Implement API call
    //     print('Scheduling meeting for ${state.contact.value?.name}');
    //     print('Date: ${meetingDateController.text}');
    //     print('Time: ${meetingTimeController.text}');
    //     print('Email: ${state.meetingEmailChecked.value}');
    //     print('WhatsApp: ${state.meetingWhatsappChecked.value}');

    //     Get.back(result: true);
    //   } finally {
    //     state.isLoading.value = false;
    //   }
    // }
  }

  void resetForm() {
    state.meetingEmailChecked.value = true;
    state.meetingWhatsappChecked.value = false;
    updateMeetingDate(DateTime.now());
    updateMeetingTime(TimeOfDay.now());

    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    meetingDateController.dispose();
    meetingTimeController.dispose();
    super.onClose();
  }
}
