import 'package:eventjar/controller/meeting/service/meeting_action_service.dart';
import 'package:eventjar/controller/meeting/service/meeting_service.dart';
import 'package:eventjar/controller/meeting/service/network_meeting_service.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/controller/schedule_meeting/availability_mixin.dart';
import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/widget/delete_confirm_dialog.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/network-meeting/network_meeting.dart';
import 'package:eventjar/page/meeting/widget/reschedule_meeting_dialog.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingController extends GetxController with AvailabilityMixin {
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
  AvailabilityState get availability => state.rescheduleAvailability;

  @override
  int get selectedDurationMins => state.rescheduleSelectedDuration.value;

  @override
  void onDurationApplied(List<int> allowedDurations) {
    if (allowedDurations.isEmpty) return;
    if (!allowedDurations.contains(state.rescheduleSelectedDuration.value)) {
      state.rescheduleSelectedDuration.value = allowedDurations.first;
    }
  }

  void selectRescheduleDuration(int mins) {
    state.rescheduleSelectedDuration.value = mins;
    onDurationChanged();
  }

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();

    _networkMeetingService = NetworkMeetingService(
      state: state,
      navigateToSignInPage: navigateToSignInPage,
    );
    _meetingService = MeetingService(
      state: state,
      navigateToSignInPage: navigateToSignInPage,
    );
    _actionService = MeetingActionService(
      state: state,
      navigateToSignInPage: navigateToSignInPage,
    );

    qualifiedDebounceWorker = ever(
      state.qualifiedSelectedDate,
      (_) => _debouncedFetchQualifiedMeetings(),
    );

    oneOnOneDebounceWorker = ever(
      state.oneOnOneSelectedDate,
      (_) => _debouncedFetchOneOnOneMeetings(),
    );

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

  // Month navigation for One-on-One tab
  void oneOnOnePreviousMonth() {
    if (state.oneOnOneDisplayedYear.value == 2025 &&
        state.oneOnOneDisplayedMonth.value == 1) return;
    if (state.oneOnOneDisplayedMonth.value == 1) {
      state.oneOnOneDisplayedMonth.value = 12;
      state.oneOnOneDisplayedYear.value--;
    } else {
      state.oneOnOneDisplayedMonth.value--;
    }
  }

  void oneOnOneNextMonth() {
    if (state.oneOnOneDisplayedMonth.value == 12) {
      state.oneOnOneDisplayedMonth.value = 1;
      state.oneOnOneDisplayedYear.value++;
    } else {
      state.oneOnOneDisplayedMonth.value++;
    }
  }

  void setOneOnOneMonthYear(int month, int year) {
    state.oneOnOneDisplayedMonth.value = month;
    state.oneOnOneDisplayedYear.value = year;
  }

  // Month navigation for Qualified Contact tab
  void qualifiedPreviousMonth() {
    if (state.qualifiedDisplayedYear.value == 2025 &&
        state.qualifiedDisplayedMonth.value == 1) return;
    if (state.qualifiedDisplayedMonth.value == 1) {
      state.qualifiedDisplayedMonth.value = 12;
      state.qualifiedDisplayedYear.value--;
    } else {
      state.qualifiedDisplayedMonth.value--;
    }
  }

  void qualifiedNextMonth() {
    if (state.qualifiedDisplayedMonth.value == 12) {
      state.qualifiedDisplayedMonth.value = 1;
      state.qualifiedDisplayedYear.value++;
    } else {
      state.qualifiedDisplayedMonth.value++;
    }
  }

  void setQualifiedMonthYear(int month, int year) {
    state.qualifiedDisplayedMonth.value = month;
    state.qualifiedDisplayedYear.value = year;
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

  String? _getTargetUserIdFromMeeting(NetworkMeeting meeting) {
    final contact = meeting.contact;
    if (contact == null) return null;

    final currentUserId = UserStore.to.profile['id'];
    final user1 = contact.user1;
    final user2 = contact.user2;

    if (user1 != null && user1['id'] == currentUserId && user2 != null) {
      return user2['id'];
    }
    if (user2 != null && user2['id'] == currentUserId && user1 != null) {
      return user1['id'];
    }
    return null;
  }

  void handleNetworkMeetingReschedule(NetworkMeeting meeting) {
    final targetUserId = _getTargetUserIdFromMeeting(meeting);
    state.rescheduleAvailability.reset();
    initAvailability(targetUserId);

    Get.dialog(RescheduleMeetingDialog(meetingId: meeting.id));
  }

  void handleConfirmedMeetingReschedule(NetworkMeeting meeting) {
    Get.dialog(
      DeleteConfirmDialog(
        title: 'reschedule_meeting'.tr,
        itemName: '',
        icon: Icons.edit_calendar_rounded,
        iconColor: Colors.orange.shade600,
        iconBgColor: Colors.orange.shade50,
        promptText:
            'This meeting is already confirmed. Rescheduling a confirmed meeting will require the other participant to re-confirm the new time.',
        warningText: 'Would you like to continue?',
        actionText: 'continue'.tr,
        actionColor: Colors.orange.shade600,
        onDelete: () => handleNetworkMeetingReschedule(meeting),
      ),
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

  Future<bool> rescheduleNetworkMeeting({required String meetingId}) async {
    final slotDt = selectedSlotDateTime;
    if (slotDt == null) return false;

    final meetingTime =
        '${slotDt.hour.toString().padLeft(2, '0')}:${slotDt.minute.toString().padLeft(2, '0')}';

    return _actionService.rescheduleNetworkMeeting(
      meetingId: meetingId,
      scheduledAtIso: slotDt.toIso8601String(),
      meetingTimeStr: meetingTime,
    );
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
    rescheduleDateController.dispose();
    rescheduleTimeController.dispose();
    qualifiedDebounceWorker.dispose();
    oneOnOneDebounceWorker.dispose();
    state.rescheduleAvailability.dispose();
    super.onClose();
  }
}
