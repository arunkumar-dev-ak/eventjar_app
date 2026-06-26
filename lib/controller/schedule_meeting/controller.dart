import 'package:eventjar/api/contact_api/config_status_api.dart';
import 'package:eventjar/api/schedule_meeting_api/schedule_meeting.dart';
import 'package:eventjar/controller/schedule_meeting/availability_mixin.dart';
import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/controller/schedule_meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleMeetingController extends GetxController with AvailabilityMixin {
  var appBarTitle = "schedule_meeting".tr;
  final state = ScheduleMeetingState();

  final formKey = GlobalKey<FormState>();
  TextEditingController meetingDateController = TextEditingController();
  TextEditingController meetingTimeController = TextEditingController();

  @override
  AvailabilityState get availability => state.availability;

  @override
  int get selectedDurationMins => state.selectedDuration.value;

  @override
  void onDurationApplied(List<int> allowedDurations) {
    if (allowedDurations.isEmpty) return;
    if (!allowedDurations.contains(state.selectedDuration.value)) {
      state.selectedDuration.value = allowedDurations.first;
    }
  }

  bool get canSendEmail => state.configStatus.value?.emailConfig ?? false;
  bool get canSendWhatsApp => state.configStatus.value?.whatsappConfig ?? false;
  bool get hasAnyMethodSelected =>
      state.meetingEmailChecked.value || state.meetingWhatsappChecked.value;

  void toggleMeetingEmail() {
    state.meetingEmailChecked.value = !state.meetingEmailChecked.value;
  }

  void toggleMeetingWhatsApp() {
    state.meetingWhatsappChecked.value = !state.meetingWhatsappChecked.value;
  }

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    final args = Get.arguments;
    state.contact.value = args;
    super.onInit();
    updateMeetingDate(DateTime.now());
    updateMeetingTime(TimeOfDay.now());
    getConfigDetails();
    _startAvailability();
  }

  void _startAvailability() {
    final contact = state.contact.value;
    if (contact == null) return;

    String? targetUserId;
    final currentUserId = UserStore.to.profile['id'];
    if (contact.isEventJarUser) {
      targetUserId = contact.user1Id == currentUserId
          ? contact.user2Id
          : contact.user1Id;
    }

    initAvailability(targetUserId);
  }

  void selectDuration(int mins) {
    state.selectedDuration.value = mins;
    onDurationChanged();
  }

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

    final slotDt = selectedSlotDateTime;

    final DateTime scheduledAtLocal;
    final String meetingTime;

    if (slotDt != null) {
      scheduledAtLocal = slotDt;
      meetingTime =
          '${slotDt.hour.toString().padLeft(2, '0')}:${slotDt.minute.toString().padLeft(2, '0')}';
    } else {
      final date = state.meetingDate.value;
      final time = state.meetingTime.value;
      scheduledAtLocal = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
      meetingTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    final utcScheduledAt = scheduledAtLocal.toUtc();

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
      method = 'email';
    }

    return {
      'contactId': contact.id,
      'scheduledAt': utcScheduledAt.toIso8601String(),
      'meetingTime': meetingTime,
      'duration': state.selectedDuration.value,
      'method': method,
      'notes': 'Contact method: $method',
    };
  }

  Future<void> scheduleMeeting(BuildContext context) async {
    if (state.isLoading.value == true) return;
    try {
      state.isLoading.value = true;

      final dto = _buildMeetingDto();

      final response = await ScheduleMeetingApi.createMeeting(dto: dto);
      if (response == true) {
        AppSnackbar.success(
          title: "meeting_scheduled".tr,
          message: "meeting_scheduled_success".tr,
        );
      }

      Navigator.pop(context, true);
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_schedule_meeting".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> getConfigDetails() async {
    try {
      state.configLoading.value = true;

      final response = await ConfigStatusApi.getConfigStatus();
      state.configStatus.value = response;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_get_config".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.configLoading.value = false;
    }
  }

  void navigateToNotification() {
    String channelArg = "";

    if (!canSendEmail && !canSendWhatsApp) {
      channelArg = "both";
    } else if (!canSendEmail) {
      channelArg = "email";
    } else if (!canSendWhatsApp) {
      channelArg = "whatsapp";
    }
    Get.toNamed(RouteName.notificationpage, arguments: channelArg)?.then((
      result,
    ) async {
      getConfigDetails();
    });
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await getConfigDetails();
      } else {
        Get.back();
      }
    });
  }

  void resetForm() {
    state.meetingEmailChecked.value = true;
    state.meetingWhatsappChecked.value = false;
    state.selectedDuration.value = 30;
    updateMeetingDate(DateTime.now());
    updateMeetingTime(TimeOfDay.now());
    state.availability.reset();
    _startAvailability();

    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    meetingDateController.dispose();
    meetingTimeController.dispose();
    state.availability.dispose();
    super.onClose();
  }
}
