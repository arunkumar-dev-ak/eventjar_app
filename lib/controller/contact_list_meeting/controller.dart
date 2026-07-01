import 'package:eventjar/api/contact_list_meeting_api/contact_list_meeting_api.dart';
import 'package:eventjar/controller/contact_list_meeting/state.dart';
import 'package:eventjar/controller/schedule_meeting/availability_mixin.dart';
import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/widget/delete_confirm_dialog.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/contact_list_meeting/widget/reschedule_meeting_conatct_list.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactListMeetingController extends GetxController
    with AvailabilityMixin {
  final state = ContactListMeetingState();
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

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
    _initializePage();
  }

  Future<void> _initializePage() async {
    final mobileContact = Get.arguments as MobileContact?;
    if (mobileContact != null) {
      state.mobileContact.value = mobileContact;
      _fetchMeetings();
    }
  }

  void _fetchMeetings() {
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

  void selectDuration(int mins) {
    state.selectedDuration.value = mins;
    onDurationChanged();
  }

  void _initAvailabilityForReschedule() {
    final contact = state.mobileContact.value;
    if (contact == null) return;

    String? targetUserId;
    final currentUserId = UserStore.to.profile['id'];
    if (contact.isEventJarUser) {
      targetUserId =
          contact.user1Id == currentUserId ? contact.user2Id : contact.user1Id;
    }

    initAvailability(targetUserId);
  }

  void onRescheduleMeeting() async {
    final meeting = state.currentMeeting.value;
    if (meeting == null) return;

    _initAvailabilityForReschedule();

    final result = await Get.dialog(
      RescheduleMeetingContactList(meetingId: meeting.id),
    );

    if (result == true) {
      Navigator.pop(Get.context!, "refresh");
    }
  }

  void onRescheduleConfirmedMeeting() {
    final meeting = state.currentMeeting.value;
    if (meeting == null) return;

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
        onDelete: () => onRescheduleMeeting(),
      ),
    );
  }

  Map<String, dynamic> _buildRescheduleDtoFromSlot() {
    final slotDt = selectedSlotDateTime;
    if (slotDt == null) return {};

    final meetingTime =
        '${slotDt.hour.toString().padLeft(2, '0')}:${slotDt.minute.toString().padLeft(2, '0')}';

    return {
      'scheduledAt': slotDt.toIso8601String(),
      'meetingTime': meetingTime,
    };
  }

  Future<bool> rescheduleMeeting({required String meetingId}) async {
    try {
      state.isRescheduling.value = true;

      final dto = _buildRescheduleDtoFromSlot();
      if (dto.isEmpty) return false;

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

  @override
  void onClose() {
    meetingDateController.dispose();
    meetingTimeController.dispose();
    state.availability.dispose();
    super.onClose();
  }
}
