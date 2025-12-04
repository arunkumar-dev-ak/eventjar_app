import 'package:eventjar/controller/schedule_meeting/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleMeetingController extends GetxController {
  var appBarTitle = "Schedule Meeting";
  final state = ScheduleMeetingState();

  final formKey = GlobalKey<FormState>();
  //meeting form
  final meetingDateController = TextEditingController();
  final meetingTimeController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    state.contact.value = args;
    super.onInit();
  }

  // Update date/time display
  void updateMeetingDateTime(DateTime dateTime) {
    state.meetingDate.value = dateTime;
    _updateDateTimeDisplay(dateTime);
  }

  void _updateDateTimeDisplay(DateTime dateTime) {
    meetingDateController.text = '${dateTime.toLocal()}'.split(' ')[0];
    meetingTimeController.text = TimeOfDay.fromDateTime(
      dateTime,
    ).format(Get.context!);
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
      updateMeetingDateTime(picked);
    }
  }

  // Pick time
  Future<void> pickMeetingTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(state.meetingTime.value),
    );
    if (picked != null) {
      final date = state.meetingDate.value;
      updateMeetingDateTime(
        DateTime(date.year, date.month, date.day, picked.hour, picked.minute),
      );
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
    state.meetingDate.value = DateTime.now();
    state.meetingTime.value = DateTime.now();
  }

  @override
  void onClose() {
    meetingDateController.dispose();
    meetingTimeController.dispose();
    super.onClose();
  }
}
