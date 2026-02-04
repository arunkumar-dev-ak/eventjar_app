import 'package:dio/dio.dart';
import 'package:eventjar/api/meeting_api/meeting_api.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingController extends GetxController {
  var appBarTitle = "My Meetings";
  final state = MeetingState();
  late Worker debounceWorker;

  @override
  void onInit() {
    super.onInit();
    debounceWorker = everAll([state.selectedStatus, state.selectedDateRange], (
      _,
    ) {
      _debouncedFetchMeetings();
    });
    state.selectedStatus.value = MeetingStatus.ALL;
    fetchMeetings(forceRefresh: true);
  }

  String getDisplayText() {
    if (state.selectedDateRange.value == null) return 'All Time';

    final start = _formatDate(state.selectedDateRange.value!.start);
    final end = _formatDate(state.selectedDateRange.value!.end);
    return '$start - $end';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = months[date.month - 1];
    return '$monthName ${date.day}, ${date.year}';
  }

  void setDate(DateTimeRange<DateTime>? range) {
    state.selectedDateRange.value =
        range ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
  }

  Future<void> _debouncedFetchMeetings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await fetchMeetings();
  }

  Map<String, dynamic> gatherQueryData() {
    final queryParams = <String, dynamic>{};

    final status = state.selectedStatus.value;
    if (status != null && status != MeetingStatus.ALL) {
      queryParams['status'] = status.name.toUpperCase();
    }

    final dateRange = state.selectedDateRange.value;
    final fromDateUtc = dateRange.start.toUtc();
    DateTime toDateUtc = dateRange.end.toUtc();

    if (fromDateUtc.isAtSameMomentAs(toDateUtc)) {
      toDateUtc = toDateUtc.add(const Duration(hours: 23, minutes: 59));
    }

    queryParams['fromDate'] = fromDateUtc.toIso8601String();
    queryParams['toDate'] = toDateUtc.toIso8601String();

    return queryParams;
  }

  Future<void> fetchMeetings({bool forceRefresh = false}) async {
    if (state.isLoading.value && !forceRefresh) return;

    try {
      if (forceRefresh) {
        state.isLoading.value = true;
      } else {
        state.isSearching.value = true;
      }

      // query params
      final queryParams = gatherQueryData();
      LoggerService.loggerInstance.dynamic_d('Query params: $queryParams');

      final response = await MeetingApi.getConnectionResponse(
        queryParams: queryParams,
      );

      state.meetings.value = response.meetings;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load Meetings");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
    } finally {
      if (state.isLoading.value) state.isLoading.value = false;
      if (state.isSearching.value) state.isSearching.value = false;
      state.buttonLoading.value = {};
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await fetchMeetings(forceRefresh: true);
      } else {
        Get.back();
      }
    });
  }

  void handleReshedulePage(ContactMeeting meeting) {
    Get.toNamed(RouteName.schedulerPage, arguments: meeting)?.then((
      result,
    ) async {
      if (result == "refresh") {
        await fetchMeetings(forceRefresh: true);
      }
    });
  }

  void navigateToSchedulePage() {
    Get.toNamed(RouteName.schedulerPage)?.then((result) async {
      if (result == "refresh") {
        await fetchMeetings(forceRefresh: true);
      } else {
        // Get.back();
      }
    });
  }

  bool _canProceed(String meetingId) {
    if (state.buttonLoading.value.isNotEmpty) return false;
    state.buttonLoading[meetingId] = true;
    return true;
  }

  void _stopLoading(String meetingId) {
    state.buttonLoading[meetingId] = false;
  }

  Future<void> completeMeeting(String meetingId) async {
    try {
      if (!_canProceed(meetingId)) {
        AppToast.warning(
          'Meeting action is in progress. Please wait for it to complete.',
        );
        return;
      }
      await MeetingApi.completeMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'Meeting Completed!',
        message: 'This meeting has been marked as completed successfully.',
      );
      fetchMeetings(forceRefresh: true);
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load Meetings");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
    } finally {
      _stopLoading(meetingId);
    }
  }

  Future<void> fetchMeetingsOnReload() async {
    await fetchMeetings(forceRefresh: false);
  }

  // Refresh data (for future API integration)
  Future<void> refreshData() async {
    state.isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void onClose() {
    debounceWorker.dispose();
    super.onClose();
  }
}
