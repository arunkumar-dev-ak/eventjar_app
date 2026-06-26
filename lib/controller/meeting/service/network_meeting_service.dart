import 'package:eventjar/api/network_meeting_api/network_meeting_api.dart';
import 'package:eventjar/controller/meeting/helper/meeting_query_helper.dart';
import 'package:eventjar/controller/meeting/state.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkMeetingService {
  final MeetingState state;
  final Function navigateToSignInPage;

  NetworkMeetingService({
    required this.state,
    required this.navigateToSignInPage,
  });

  Future<void> fetchOneOnOneMeetings({bool forceRefresh = false}) async {
    if (state.isOneOnOneLoading.value && !forceRefresh) return;

    state.isOneOnOneLoading.value = true;
    try {
      final date = state.oneOnOneSelectedDate.value;
      final dateRange = DateTimeRange(
        start: DateTime(date.year, date.month, date.day),
        end: DateTime(date.year, date.month, date.day, 23, 59, 59),
      );
      final queryParams = MeetingQueryHelper.gatherOneOnOneQueryData(
        status: null,
        dateRange: dateRange,
      );

      final response = await NetworkMeetingApi.getNetworkMeetings(
        queryParams: queryParams,
      );

      state.oneOnOneMeetings.value = response.data;
      state.oneOnOneNextCursor.value = response.paging.cursors.next;
      state.oneOnOneHasNextPage.value = response.paging.hasNextPage;
    } catch (err) {
      _handleError(err);
    } finally {
      state.isOneOnOneLoading.value = false;
    }
  }

  Future<void> fetchOneOnOneMeetingsOnScroll() async {
    if (state.isOneOnOneLoadingMore.value) return;

    state.isOneOnOneLoadingMore.value = true;
    try {
      final date = state.oneOnOneSelectedDate.value;
      final dateRange = DateTimeRange(
        start: DateTime(date.year, date.month, date.day),
        end: DateTime(date.year, date.month, date.day, 23, 59, 59),
      );
      final queryParams = MeetingQueryHelper.gatherOneOnOneQueryData(
        status: null,
        dateRange: dateRange,
        cursor: state.oneOnOneNextCursor.value,
      );

      final response = await NetworkMeetingApi.getNetworkMeetings(
        queryParams: queryParams,
      );

      state.oneOnOneMeetings.addAll(response.data);
      state.oneOnOneNextCursor.value = response.paging.cursors.next;
      state.oneOnOneHasNextPage.value = response.paging.hasNextPage;
    } catch (err) {
      _handleError(err);
    } finally {
      state.isOneOnOneLoadingMore.value = false;
    }
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
}
