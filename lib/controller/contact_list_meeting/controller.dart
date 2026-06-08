import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_list_meeting_api/contact_list_meeting_api.dart';
import 'package:eventjar/controller/contact_list_meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact_list_meeting/widget/reschedule_meeting_conatct_list.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactListMeetingController extends GetxController {
  final state = ContactListMeetingState();
  TextEditingController meetingDateController = TextEditingController();
  TextEditingController meetingTimeController = TextEditingController();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
    _initializePage();
  }

  Future<void> _initializePage() async {
    // Get MobileContact from args
    final mobileContact = Get.arguments as MobileContact?;
    if (mobileContact != null) {
      state.mobileContact.value = mobileContact;
      _fetchMeetings();
    }
  }

  void _fetchMeetings() {
    // try {
    //   state.isShimmerLoading.value = true;
    //   state.isLoading.value = true;

    //   String endpoint;

    //   bool isCompleted = state.mobileContact.value?.meetingCompleted ?? false;
    //   bool isConfirmed = state.mobileContact.value?.meetingConfirmed ?? false;
    //   bool isScheduled = state.mobileContact.value?.meetingScheduled ?? false;

    //   if (isCompleted || !isScheduled) {
    //     state.currentMeeting.value = null;
    //   } else {
    //     final status = isConfirmed ? 'CONFIRMED' : 'SCHEDULED';

    //     endpoint = '/network-meetings?contactId=$contactId&status=$status';
    //     LoggerService.loggerInstance.dynamic_d(endpoint);
    //     NetworkMeetingsListResponse response =
    //         await ContactListMeetingApi.getNetworkMeeting(endpoint);
    //     state.currentMeeting.value = response.meetings.first;
    //     LoggerService.loggerInstance.dynamic_d(
    //       state.currentMeeting.value?.toJson(),
    //     );
    //     _updateButtonType();
    //   }
    // } catch (e) {
    //   debugPrint('Error fetching meetings: $e');
    //   if (e is DioException) {
    //     Get.snackbar('Error', 'Failed to load meetings');
    //   }
    // } finally {
    //   state.isShimmerLoading.value = false;
    //   state.isLoading.value = false;
    // }
    // LoggerService.loggerInstance.dynamic_d(state.mobileContact)
    bool isCompleted =
        state.mobileContact.value?.activeMeeting?.completedAt != null;

    if (isCompleted) {
      state.currentMeeting.value = null;
    } else {
      state.currentMeeting.value = state.mobileContact.value!.activeMeeting!;
    }

    _updateButtonType();
  }

  void _updateButtonType() {
    final meeting = state.currentMeeting.value;
    if (meeting != null) {
      switch (meeting.status) {
        case 'SCHEDULED':
          state.primaryButtonType.value = MeetingButtonType.accept;
          break;
        case 'CONFIRMED':
          state.primaryButtonType.value = MeetingButtonType.complete;
          break;
        default:
          state.primaryButtonType.value = MeetingButtonType.accept;
      }
    }
  }

  Future<void> onAcceptMeeting(String meetingId) async {
    state.isLoading.value = true;
    try {
      await ContactListMeetingApi.confirmMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'meeting_completed'.tr,
        message: 'meeting_marked_accepted'.tr,
      );
      Navigator.pop(Get.context!, "refresh");
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to chnage status",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  /*----- Reschedule Meeting -----*/
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
    final date = state.meetingDate.value;
    final time = state.meetingTime.value;

    // 1. Combine date and time (creates a localized DateTime object)
    final localScheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // 2. Explicitly convert to UTC so it appends the 'Z' properly
    final utcScheduledAt = localScheduledAt.toUtc();

    final meetingTimeFormatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return {
      'scheduledAt': utcScheduledAt.toIso8601String(),
      'meetingTime': meetingTimeFormatted,
    };
  }

  Future<bool> rescheduleMeeting({required String meetingId}) async {
    try {
      state.isRescheduling.value = true;

      final dto = _buildMeetingDto();

      await ContactListMeetingApi.rescheduleMeeting(id: meetingId, dto: dto);
      AppSnackbar.success(
        title: "Success",
        message: "meeting_rescheduled_success".tr,
      );

      return true;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_change_status".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
      return false;
    } finally {
      state.isRescheduling.value = false;
    }
  }

  void onRescheduleMeeting() async {
    final meeting = state.currentMeeting.value;
    if (meeting == null) return;

    // 1. FIXED: Convert the UTC database time to the user's local device time
    final localDateTime = meeting.scheduledAt.toLocal();
    LoggerService.loggerInstance.dynamic_d(localDateTime);
    updateMeetingDate(localDateTime);

    // 2. Fallback check for time parsing
    if (meeting.meetingTime != null && meeting.meetingTime!.contains(':')) {
      final timeParts = meeting.meetingTime!.split(":");
      updateMeetingTime(
        TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        ),
      );
    } else {
      // If meetingTime is missing or corrupt, fallback cleanly to the localDateTime hours/minutes
      updateMeetingTime(
        TimeOfDay(hour: localDateTime.hour, minute: localDateTime.minute),
      );
    }

    final result = await Get.dialog(
      RescheduleMeetingContactList(meetingId: meeting.id),
    );

    if (result == true) {
      Navigator.pop(Get.context!, "refresh");
    }
  }

  /*-----Complete Meeting -----*/
  Future<void> onCompleteMeeting(String meetingId) async {
    state.isLoading.value = true;
    try {
      await ContactListMeetingApi.completeMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'meeting_completed'.tr,
        message: 'This meeting has been marked as completed successfully.',
      );
      Navigator.pop(Get.context!, "refresh");
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_change_status".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> _updateMeetingStatus(String status) async {
    try {
      state.isLoading.value = true;
      // TODO: Call API to update meeting status
      // await updateMeetingApi(state.currentMeeting.value!.id, status);

      // Update local state
      final meeting = state.currentMeeting.value!;
      // state.currentMeeting.value = meeting.copyWith(status: status);
      _updateButtonType();

      Get.snackbar('Success', 'Meeting updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update meeting');
    } finally {
      state.isLoading.value = false;
    }
  }

  String get formattedDate => state.currentMeeting.value != null
      ? _formatDate(state.currentMeeting.value!.scheduledAt)
      : '';

  String get formattedTime => state.currentMeeting.value?.meetingTime ?? '';

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }
}
