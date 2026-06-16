import 'package:eventjar/api/meeting_api/meeting_api.dart';
import 'package:eventjar/controller/meeting/helper/meeting_query_helper.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:get/get.dart';

class MeetingService {
  final MeetingState state;
  final Function navigateToSignInPage;

  MeetingService({required this.state, required this.navigateToSignInPage});

  Future<void> fetchMeetings({bool forceRefresh = false}) async {
    if (state.isLoading.value && !forceRefresh) return;

    try {
      if (forceRefresh) {
        state.isLoading.value = true;
      } else {
        state.isSearching.value = true;
      }

      final queryParams = MeetingQueryHelper.gatherQueryData(
        status: state.selectedStatus.value,
        dateRange: state.selectedDateRange.value,
      );

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
}
