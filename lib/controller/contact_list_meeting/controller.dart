import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_list_meeting_api/contact_list_meeting_api.dart';
import 'package:eventjar/controller/contact_list_meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/contact-list-meeting/network_meeting.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactListMeetingController extends GetxController {
  final state = ContactListMeetingState();

  @override
  void onInit() {
    super.onInit();
    _initializePage();
  }

  Future<void> _initializePage() async {
    // Get MobileContact from args
    final mobileContact = Get.arguments as MobileContact?;
    if (mobileContact != null) {
      state.mobileContact.value = mobileContact;
      await _fetchMeetings(mobileContact.id);
    }
  }

  Future<void> _fetchMeetings(String contactId) async {
    try {
      state.isShimmerLoading.value = true;
      state.isLoading.value = true;

      String endpoint;

      bool isCompleted = state.mobileContact.value?.meetingCompleted ?? false;
      bool isConfirmed = state.mobileContact.value?.meetingConfirmed ?? false;
      bool isScheduled = state.mobileContact.value?.meetingScheduled ?? false;

      if (isCompleted || !isScheduled) {
        state.currentMeeting.value = null;
      } else {
        final status = isConfirmed ? 'CONFIRMED' : 'SCHEDULED';

        endpoint = '/network-meetings?contactId=$contactId&status=$status';
        LoggerService.loggerInstance.dynamic_d(endpoint);
        NetworkMeetingsListResponse response =
            await ContactListMeetingApi.getNetworkMeeting(endpoint);
        state.currentMeeting.value = response.meetings.first;
        LoggerService.loggerInstance.dynamic_d(
          state.currentMeeting.value?.toJson(),
        );
        _updateButtonType();
      }
    } catch (e) {
      debugPrint('Error fetching meetings: $e');
      if (e is DioException) {
        Get.snackbar('Error', 'Failed to load meetings');
      }
    } finally {
      state.isShimmerLoading.value = false;
      state.isLoading.value = false;
    }
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
    LoggerService.loggerInstance.dynamic_d(meetingId);
    state.isLoading.value = true;
    try {
      await ContactListMeetingApi.confirmMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'Meeting Completed!',
        message: 'This meeting has been marked as accepted successfully.',
      );
      Get.back();
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to change Status");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> onRescheduleMeeting() async {
    // Navigate to reschedule page
    // Get.toNamed('/reschedule-meeting', arguments: state.currentMeeting.value);
  }

  Future<void> onCompleteMeeting(String meetingId) async {
    state.isLoading.value = true;
    try {
      await ContactListMeetingApi.completeMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'Meeting Completed!',
        message: 'This meeting has been marked as completed successfully.',
      );
      Get.back(result: "refresh");
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to change Status");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
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
