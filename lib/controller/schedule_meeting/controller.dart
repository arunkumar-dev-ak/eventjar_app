import 'package:dio/dio.dart';
import 'package:eventjar/api/schedule_meeting_api/schedule_meeting.dart';
import 'package:eventjar/controller/schedule_meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
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

  Map<String, dynamic> _buildMeetingDto() {
    final contact = state.contact.value!;
    final date = state.meetingDate.value;
    final time = state.meetingTime.value;

    // Combine Date + Time into a single DateTime like web code does. [web:26][web:35]
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Decide method like web: 'email' | 'whatsapp' | 'both'
    String method;
    final email = state.meetingEmailChecked.value;
    final whatsapp = state.meetingWhatsappChecked.value;

    if (email && whatsapp) {
      method = 'both';
    } else if (email) {
      method = 'email';
    } else if (whatsapp) {
      method = 'whatsapp';
    } else {
      // fallback to email if user unchecks everything
      method = 'email';
    }

    // meetingTime in "HH:mm" format
    final meetingTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return {
      'contactId': contact.id,
      'scheduledAt': scheduledAt.toIso8601String(),
      'meetingTime': meetingTime,
      'duration': 60,
      'method': method,
      'notes': 'Contact method: $method',
    };
  }

  // Schedule meeting
  Future<void> scheduleMeeting(BuildContext context) async {
    if (state.isLoading.value == true) return;
    try {
      state.isLoading.value = true;

      final dto = _buildMeetingDto();

      LoggerService.loggerInstance.dynamic_d(dto);

      final response = await ScheduleMeetingApi.createMeeting(dto: dto);
      if (response == true) {
        AppSnackbar.success(
          title: "Meeting scheduled",
          message: "Your meeting has been scheduled successfully.",
        );
      }

      Navigator.pop(context, true);
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to Schedule Meeting");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
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
