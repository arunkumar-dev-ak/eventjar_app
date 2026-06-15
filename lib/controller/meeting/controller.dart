import 'package:eventjar/api/meeting_api/meeting_api.dart';
import 'package:eventjar/api/network_meeting_api/network_meeting_api.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:eventjar/model/network-meeting/network_meeting.dart';
import 'package:eventjar/page/meeting/widget/reschedule_meeting_dialog.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingController extends GetxController {
  var appBarTitle = "my_meetings".tr;
  final state = MeetingState();
  late Worker debounceWorker;
  late Worker oneOnOneDebounceWorker;

  final oneOnOneScrollController = ScrollController();
  final qualifiedContactScrollController = ScrollController();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
    debounceWorker = everAll([state.selectedStatus, state.selectedDateRange], (
      _,
    ) {
      _debouncedFetchMeetings();
    });
    oneOnOneDebounceWorker = everAll(
      [state.oneOnOneSelectedStatus, state.oneOnOneSelectedDateRange],
      (_) {
        _debouncedFetchOneOnOneMeetings();
      },
    );
    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['status'] != null) {
      state.selectedStatus.value = args['status'] as MeetingStatus;
    } else {
      state.selectedStatus.value = MeetingStatus.ALL;
    }
    state.oneOnOneSelectedStatus.value = MeetingStatus.ALL;

    oneOnOneScrollController.addListener(_onOneOnOneScroll);
    qualifiedContactScrollController.addListener(_onQualifiedContactScroll);

    fetchOneOnOneMeetings(forceRefresh: true);
  }

  void _onOneOnOneScroll() {
    if (state.selectedTab.value != 0) return;
    if (!oneOnOneScrollController.hasClients) return;

    if (oneOnOneScrollController.position.pixels >=
        oneOnOneScrollController.position.maxScrollExtent - 200) {
      if (state.oneOnOneHasNextPage.value &&
          !state.isOneOnOneLoadingMore.value) {
        fetchOneOnOneMeetingsOnScroll();
      }
    }
  }

  void _onQualifiedContactScroll() {
    if (state.selectedTab.value != 1) return;
    if (!qualifiedContactScrollController.hasClients) return;
  }

  void changeTab(int index) {
    if (state.selectedTab.value == index) return;
    state.selectedTab.value = index;
    if (index == 0) {
      fetchOneOnOneMeetings(forceRefresh: true);
    } else {
      fetchMeetings(forceRefresh: true);
    }
  }

  Future<void> _debouncedFetchOneOnOneMeetings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await fetchOneOnOneMeetings(forceRefresh: true);
  }

  Map<String, dynamic> gatherOneOnOneQueryData({String? cursor}) {
    final queryParams = <String, dynamic>{
      'limit': 10,
    };

    final status = state.oneOnOneSelectedStatus.value;
    if (status != null && status != MeetingStatus.ALL) {
      queryParams['status'] = status.name.toUpperCase();
    }

    final dateRange = state.oneOnOneSelectedDateRange.value;
    final fromDateUtc = dateRange.start.toUtc();
    DateTime toDateUtc = dateRange.end.toUtc();

    if (fromDateUtc.isAtSameMomentAs(toDateUtc)) {
      toDateUtc = toDateUtc.add(const Duration(hours: 23, minutes: 59));
    }

    queryParams['fromDate'] = fromDateUtc.toIso8601String();
    queryParams['toDate'] = toDateUtc.toIso8601String();

    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }

    return queryParams;
  }

  String getOneOnOneDisplayText() {
    final start = _formatDate(state.oneOnOneSelectedDateRange.value.start);
    final end = _formatDate(state.oneOnOneSelectedDateRange.value.end);
    return '$start - $end';
  }

  void setOneOnOneDate(DateTimeRange<DateTime>? range) {
    state.oneOnOneSelectedDateRange.value =
        range ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
  }

  Future<void> fetchOneOnOneMeetings({bool forceRefresh = false}) async {
    if (state.isOneOnOneLoading.value && !forceRefresh) return;

    state.isOneOnOneLoading.value = true;
    try {
      final queryParams = gatherOneOnOneQueryData();

      final response = await NetworkMeetingApi.getNetworkMeetings(
        queryParams: queryParams,
      );

      state.oneOnOneMeetings.value = response.data;
      state.oneOnOneNextCursor.value = response.paging.cursors.next;
      state.oneOnOneHasNextPage.value = response.paging.hasNextPage;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isOneOnOneLoading.value = false;
    }
  }

  Future<void> fetchOneOnOneMeetingsOnScroll() async {
    if (state.isOneOnOneLoadingMore.value) return;

    state.isOneOnOneLoadingMore.value = true;
    try {
      final queryParams = gatherOneOnOneQueryData(
        cursor: state.oneOnOneNextCursor.value,
      );

      final response = await NetworkMeetingApi.getNetworkMeetings(
        queryParams: queryParams,
      );

      state.oneOnOneMeetings.addAll(response.data);
      state.oneOnOneNextCursor.value = response.paging.cursors.next;
      state.oneOnOneHasNextPage.value = response.paging.hasNextPage;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isOneOnOneLoadingMore.value = false;
    }
  }

  void handleOneOnOneMeetingTap(NetworkMeeting meeting) {
    final status = meeting.status.toLowerCase();
    if (status == 'scheduled' || status == 'confirmed') {
      Get.toNamed(RouteName.contactListMeetingPage, arguments: meeting.toContactMeeting())?.then((
        result,
      ) async {
        if (result == "refresh") {
          await fetchOneOnOneMeetings(forceRefresh: true);
        }
      });
    }
  }

  Future<void> confirmNetworkMeeting(String meetingId) async {
    try {
      if (!_canProceed(meetingId)) {
        AppToast.warning(
          'Meeting action is in progress. Please wait for it to complete.',
        );
        return;
      }
      await NetworkMeetingApi.confirmMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'meeting_confirmed'.tr,
        message: 'meeting_confirmed_desc'.tr,
      );
      fetchOneOnOneMeetings(forceRefresh: true);
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      _stopLoading(meetingId);
    }
  }

  Future<void> completeNetworkMeeting(String meetingId) async {
    try {
      if (!_canProceed(meetingId)) {
        AppToast.warning(
          'Meeting action is in progress. Please wait for it to complete.',
        );
        return;
      }
      await NetworkMeetingApi.completeMeeting(id: meetingId);
      AppSnackbar.success(
        title: 'meeting_completed'.tr,
        message: 'meeting_marked_completed'.tr,
      );
      fetchOneOnOneMeetings(forceRefresh: true);
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      _stopLoading(meetingId);
    }
  }

  final rescheduleDateController = TextEditingController();
  final rescheduleTimeController = TextEditingController();

  void handleNetworkMeetingReschedule(NetworkMeeting meeting) {
    final localDateTime = meeting.scheduledAt.toLocal();
    state.rescheduleMeetingDate.value = localDateTime;
    state.rescheduleMeetingTime.value = TimeOfDay(
      hour: localDateTime.hour,
      minute: localDateTime.minute,
    );
    rescheduleDateController.text =
        '${localDateTime.day.toString().padLeft(2, '0')}-'
        '${localDateTime.month.toString().padLeft(2, '0')}-${localDateTime.year}';
    rescheduleTimeController.text =
        state.rescheduleMeetingTime.value.format(Get.context!);

    Get.dialog(
      RescheduleMeetingDialog(meetingId: meeting.id),
    );
  }

  Future<void> pickRescheduleDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: state.rescheduleMeetingDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      state.rescheduleMeetingDate.value = picked;
      rescheduleDateController.text =
          '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  Future<void> pickRescheduleTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: state.rescheduleMeetingTime.value,
    );
    if (picked != null) {
      state.rescheduleMeetingTime.value = picked;
      rescheduleTimeController.text = picked.format(Get.context!);
    }
  }

  Future<bool> rescheduleNetworkMeeting({required String meetingId}) async {
    try {
      state.isRescheduling.value = true;

      final date = state.rescheduleMeetingDate.value;
      final time = state.rescheduleMeetingTime.value;
      final localScheduledAt = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
      final utcScheduledAt = localScheduledAt.toUtc();
      final meetingTimeFormatted =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      final dto = {
        'scheduledAt': utcScheduledAt.toIso8601String(),
        'meetingTime': meetingTimeFormatted,
      };

      await NetworkMeetingApi.rescheduleMeeting(id: meetingId, dto: dto);
      AppSnackbar.success(
        title: 'success'.tr,
        message: 'meeting_rescheduled_success'.tr,
      );
      return true;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
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

  String getDisplayText() {
    final start = _formatDate(state.selectedDateRange.value.start);
    final end = _formatDate(state.selectedDateRange.value.end);
    return '$start - $end';
  }

  String _formatDate(DateTime date) {
    final months = [
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr,
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

      final response = await MeetingApi.getConnectionResponse(
        queryParams: queryParams,
      );

      state.meetings.value = response.meetings;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
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
    if (state.buttonLoading.values.any((v) => v == true)) return false;
    state.buttonLoading[meetingId] = true;
    return true;
  }

  void _stopLoading(String meetingId) {
    state.buttonLoading.remove(meetingId);
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
        title: 'meeting_completed'.tr,
        message: 'meeting_marked_completed'.tr,
      );
      fetchMeetings(forceRefresh: true);
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_meetings".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      _stopLoading(meetingId);
    }
  }

  Future<void> fetchMeetingsOnReload() async {
    await fetchMeetings(forceRefresh: false);
  }

  Future<void> refreshData() async {
    state.isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void onClose() {
    oneOnOneScrollController.removeListener(_onOneOnOneScroll);
    qualifiedContactScrollController.removeListener(_onQualifiedContactScroll);
    oneOnOneScrollController.dispose();
    qualifiedContactScrollController.dispose();
    debounceWorker.dispose();
    oneOnOneDebounceWorker.dispose();
    super.onClose();
  }
}
