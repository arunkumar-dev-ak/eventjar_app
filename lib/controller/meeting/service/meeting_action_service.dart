import 'package:eventjar/api/meeting_api/meeting_api.dart';
import 'package:eventjar/api/network_meeting_api/network_meeting_api.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:get/get.dart';

class MeetingActionService {
  final MeetingState state;
  final Function navigateToSignInPage;

  MeetingActionService({
    required this.state,
    required this.navigateToSignInPage,
  });

  bool _canProceed(String meetingId) {
    if (state.buttonLoading.values.any((v) => v == true)) return false;
    state.buttonLoading[meetingId] = true;
    return true;
  }

  void _stopLoading(String meetingId) {
    state.buttonLoading.remove(meetingId);
  }

  void _handleError(dynamic err) {
    ApiErrorHandler.handle(
      error: err,
      title: "failed_load_meetings".tr,
      onUnauthorized: () {
        UserStore.to.clearStore();
        navigateToSignInPage();
      },
    );
  }

  //Network Meeting
  Future<void> confirmNetworkMeeting(
    String meetingId,
    Function onSuccess,
  ) async {
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
      onSuccess();
    } catch (err) {
      _handleError(err);
    } finally {
      _stopLoading(meetingId);
    }
  }

  Future<void> completeNetworkMeeting(
    String meetingId,
    Function onSuccess,
  ) async {
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
      onSuccess();
    } catch (err) {
      _handleError(err);
    } finally {
      _stopLoading(meetingId);
    }
  }

  Future<bool> rescheduleNetworkMeeting({
    required String meetingId,
    required String scheduledAtIso,
    required String meetingTimeStr,
  }) async {
    try {
      state.isRescheduling.value = true;

      final dto = {
        'scheduledAt': scheduledAtIso,
        'meetingTime': meetingTimeStr,
      };

      await NetworkMeetingApi.rescheduleMeeting(id: meetingId, dto: dto);
      AppSnackbar.success(
        title: 'success'.tr,
        message: 'meeting_rescheduled_success'.tr,
      );
      return true;
    } catch (err) {
      _handleError(err);
      return false;
    } finally {
      state.isRescheduling.value = false;
    }
  }

  //Qualified Contact Meeting
  Future<void> completeMeeting(String meetingId, Function onSuccess) async {
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
      onSuccess();
    } catch (err) {
      _handleError(err);
    } finally {
      _stopLoading(meetingId);
    }
  }
}
