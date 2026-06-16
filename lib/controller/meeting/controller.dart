import 'package:eventjar/controller/meeting/helper/meeting_date_helper.dart';
import 'package:eventjar/controller/meeting/service/meeting_action_service.dart';
import 'package:eventjar/controller/meeting/service/meeting_service.dart';
import 'package:eventjar/controller/meeting/service/network_meeting_service.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:eventjar/model/network-meeting/network_meeting.dart';
import 'package:eventjar/page/meeting/widget/reschedule_meeting_dialog.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingController extends GetxController {
  var appBarTitle = "my_meetings".tr;
  final state = MeetingState();

  late Worker qualifiedDebounceWorker;
  late Worker oneOnOneDebounceWorker;

  final oneOnOneScrollController = ScrollController();
  final qualifiedContactScrollController = ScrollController();

  final rescheduleDateController = TextEditingController();
  final rescheduleTimeController = TextEditingController();

  // Core Service Modules
  late final NetworkMeetingService _networkMeetingService;
  late final MeetingService _meetingService;
  late final MeetingActionService _actionService;

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();

    //one on one
    _networkMeetingService = NetworkMeetingService(
      state: state,
      navigateToSignInPage: navigateToSignInPage,
    );
    //qualified contact
    _meetingService = MeetingService(
      state: state,
      navigateToSignInPage: navigateToSignInPage,
    );
    //form actions
    _actionService = MeetingActionService(
      state: state,
      navigateToSignInPage: navigateToSignInPage,
    );

    qualifiedDebounceWorker = everAll(
      [state.selectedStatus, state.selectedDateRange],
      (_) {
        _debouncedFetchQualifiedMeetings();
      },
    );

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
        _networkMeetingService.fetchOneOnOneMeetingsOnScroll();
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

  Future<void> _debouncedFetchQualifiedMeetings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await fetchMeetings();
  }

  // Delegate down to Services/Helpers
  String getOneOnOneDisplayText() => MeetingDateHelper.getDateRangeDisplayText(
    state.oneOnOneSelectedDateRange.value,
  );
  String getDisplayText() =>
      MeetingDateHelper.getDateRangeDisplayText(state.selectedDateRange.value);

  void setOneOnOneDate(DateTimeRange<DateTime>? range) {
    state.oneOnOneSelectedDateRange.value =
        range ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
  }

  void setDate(DateTimeRange<DateTime>? range) {
    state.selectedDateRange.value =
        range ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
  }

  Future<void> fetchOneOnOneMeetings({bool forceRefresh = false}) =>
      _networkMeetingService.fetchOneOnOneMeetings(forceRefresh: forceRefresh);
  Future<void> fetchMeetings({bool forceRefresh = false}) =>
      _meetingService.fetchMeetings(forceRefresh: forceRefresh);

  Future<void> confirmNetworkMeeting(String meetingId) =>
      _actionService.confirmNetworkMeeting(
        meetingId,
        () => fetchOneOnOneMeetings(forceRefresh: true),
      );
  Future<void> completeNetworkMeeting(String meetingId) =>
      _actionService.completeNetworkMeeting(
        meetingId,
        () => fetchOneOnOneMeetings(forceRefresh: true),
      );
  Future<void> completeMeeting(String meetingId) => _actionService
      .completeMeeting(meetingId, () => fetchMeetings(forceRefresh: true));

  void handleNetworkMeetingReschedule(NetworkMeeting meeting) {
    final localDateTime = meeting.scheduledAt.toLocal();
    state.rescheduleMeetingDate.value = localDateTime;
    state.rescheduleMeetingTime.value = TimeOfDay(
      hour: localDateTime.hour,
      minute: localDateTime.minute,
    );
    rescheduleDateController.text =
        '${localDateTime.day.toString().padLeft(2, '0')}-${localDateTime.month.toString().padLeft(2, '0')}-${localDateTime.year}';
    rescheduleTimeController.text = state.rescheduleMeetingTime.value.format(
      Get.context!,
    );

    Get.dialog(RescheduleMeetingDialog(meetingId: meeting.id));
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
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
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

  Future<bool> rescheduleNetworkMeeting({required String meetingId}) =>
      _actionService.rescheduleNetworkMeeting(
        meetingId: meetingId,
        date: state.rescheduleMeetingDate.value,
        time: state.rescheduleMeetingTime.value,
      );

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
      if (result == "refresh") await fetchMeetings(forceRefresh: true);
    });
  }

  void navigateToSchedulePage() {
    Get.toNamed(RouteName.schedulerPage)?.then((result) async {
      if (result == "refresh") await fetchMeetings(forceRefresh: true);
    });
  }

  Future<void> fetchMeetingsOnReload() async =>
      fetchMeetings(forceRefresh: false);

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
    qualifiedDebounceWorker.dispose();
    oneOnOneDebounceWorker.dispose();
    super.onClose();
  }
}
