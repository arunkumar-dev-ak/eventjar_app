import 'package:dio/dio.dart';
import 'package:eventjar/api/connection_api/connection_api.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/connection/connection_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:eventjar/controller/connection/state.dart';

class ConnectionController extends GetxController {
  final state = ConnState();
  final sentScrollController = ScrollController();
  final receivedScrollController = ScrollController();
  late Worker _statusDebounceWorker;

  @override
  void onInit() async {
    // await UserStore.to.deleteAccessToken();
    onOpen();
    super.onInit();
    sentScrollController.addListener(_onSentScroll);
    receivedScrollController.addListener(_onReceivedScroll);
    configureDebounce();
  }

  void configureDebounce() {
    _statusDebounceWorker = debounce<String>(state.selectedStatus, (_) {
      fetchConnections();
    }, time: const Duration(milliseconds: 400));
  }

  void _onSentScroll() {
    if (state.selectedTab.value != 0) return;
    if (!sentScrollController.hasClients) return;

    final currentPage = state.sent.value?.page ?? 1;
    final totalPage = state.sent.value?.totalPages ?? 1;

    if (sentScrollController.position.pixels >=
        sentScrollController.position.maxScrollExtent - 200) {
      if (currentPage < totalPage && !state.isLoading.value) {
        fetchConnectionsOnScroll(isSent: true);
      }
    }
  }

  void _onReceivedScroll() {
    if (state.selectedTab.value != 1) return;
    if (!receivedScrollController.hasClients) return;

    final currentPage = state.received.value?.page ?? 1;
    final totalPage = state.received.value?.totalPages ?? 1;

    if (receivedScrollController.position.pixels >=
        receivedScrollController.position.maxScrollExtent - 200) {
      if (currentPage < totalPage && !state.isLoading.value) {
        fetchConnectionsOnScroll(isSent: false);
      }
    }
  }

  final searchController = TextEditingController();

  void onOpen() {
    fetchConnections();
  }

  void changeTab(int index) async {
    if (state.selectedTab.value == index) return;
    state.selectedTab.value = index;
    if (index == 0) {
      await fetchConnections();
    }

    if (index == 1) {
      await fetchConnections();
    }
  }

  Future<void> fetchConnections() async {
    state.isLoading.value = true;

    try {
      final isSentTab = state.selectedTab.value == 0;
      final statusToUse = state.selectedStatus.value;

      final queryParams = <String, dynamic>{
        'sentPage': 1,
        'receivedPage': 1,
        'sentLimit': isSentTab ? 10 : 1,
        'receivedLimit': isSentTab ? 1 : 10,
      };

      if (statusToUse != 'all') {
        queryParams['status'] = statusToUse;
      }

      final response = await ConnectionApi.getConnectionResponse(
        queryParams: queryParams,
      );

      state.sent.value = response.sent;
      state.received.value = response.received;

      LoggerService.loggerInstance.d("Connections fetched successfully");
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to fetch analytics");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      checkAndMakeLoadingFalse();
    }
  }

  Future<void> fetchConnectionsOnScroll({required bool isSent}) async {
    if (isSent) {
      if (state.isSentLoadingMore.value) return;
      state.isSentLoadingMore.value = true;
    } else {
      if (state.isReceivedLoadingMore.value) return;
      state.isReceivedLoadingMore.value = true;
    }

    try {
      final isSentTab = state.selectedTab.value == 0;
      final statusToUse = state.selectedStatus.value;

      final queryParams = <String, dynamic>{
        'sentPage': isSentTab ? (state.sent.value?.page ?? 0) + 1 : 1,
        'receivedPage': isSentTab ? 1 : (state.received.value?.page ?? 0) + 1,
        'sentLimit': isSentTab ? 10 : 1,
        'receivedLimit': isSentTab ? 1 : 10,
      };

      if (statusToUse != 'all') {
        queryParams['status'] = statusToUse;
      }

      final response = await ConnectionApi.getConnectionResponse(
        queryParams: queryParams,
      );

      if (isSent) {
        final existing = state.sent.value;

        state.sent.value = SentRequests(
          count: response.sent.count,
          total: response.sent.total,
          page: response.sent.page,
          limit: response.sent.limit,
          totalPages: response.sent.totalPages,
          requests: [...existing?.requests ?? [], ...response.sent.requests],
        );
      } else {
        final existing = state.received.value;

        state.received.value = ReceivedRequests(
          count: response.received.count,
          total: response.received.total,
          page: response.received.page,
          limit: response.received.limit,
          totalPages: response.received.totalPages,
          requests: [
            ...existing?.requests ?? [],
            ...response.received.requests,
          ],
        );
      }
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to fetch Connection Details");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      checkAndMakeLoadingFalse();
    }
  }

  void checkAndMakeLoadingFalse() {
    bool isLoading = state.isLoading.value;
    bool isSentLoadingMore = state.isSentLoadingMore.value;
    bool isReceivedLoadingMore = state.isReceivedLoadingMore.value;

    if (isLoading) {
      state.isLoading.value = false;
    }
    if (isSentLoadingMore) {
      state.isSentLoadingMore.value = false;
    }
    if (isReceivedLoadingMore) {
      state.isReceivedLoadingMore.value = false;
    }
  }

  Future<void> refreshConnections() async {
    // isLoading.value = true;
    // // Simulate API
    // await Future.delayed(const Duration(seconds: 1));
    // state.sentRequests.value = _generateDummyRequests(10, true);
    // state.receivedRequests.value = _generateDummyRequests(15, false);
    // state.sentTotalPages.value = 3;
    // state.receivedTotalPages.value = 4;
    // state.pendingReceivedCount.value = state.receivedRequests
    //     .where((r) => r.status == 'pending')
    //     .length;
    // isLoading.value = false;
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        onOpen();
      } else {
        // dashboardController.state.selectedIndex.value = 0;
      }
    });
  }

  void navigateToEventPage(String eventId) {
    // Get.toNamed(RouteName.eventInfoPage, parameters: {'eventId': eventId});
  }

  void onSearchChange(String query) {
    /* Filter logic */
  }

  void onStatusFilterChange(String? status) {
    state.selectedStatus.value = status ?? 'all';
  }

  /*----- status change -----*/
  bool get _hasAnyLoading =>
      state.buttonLoading.values.any((isLoading) => isLoading == true);

  bool _canProceed(String requestId) {
    if (_hasAnyLoading) return false;
    state.buttonLoading[requestId] = true;
    return true;
  }

  void _stopLoading(String requestId) {
    state.buttonLoading[requestId] = false;
  }

  void _updateRequestByIndex({
    required bool isSent,
    required int index,
    required String requestId,
    required String newStatus,
  }) {
    final list = isSent
        ? state.sent.value?.requests
        : state.received.value?.requests;

    if (list == null) return;
    if (index < 0 || index >= list.length) return;
    if (list[index].id != requestId) return;

    final updated = list[index];

    list[index] = ConnectionRequest(
      id: updated.id,
      eventId: updated.eventId,
      eventTitle: updated.eventTitle,
      eventStartDate: updated.eventStartDate,
      fromUserId: updated.fromUserId,
      fromUserName: updated.fromUserName,
      fromUserUsername: updated.fromUserUsername,
      fromUserEmail: updated.fromUserEmail,
      fromUserAvatar: updated.fromUserAvatar,
      fromUserPosition: updated.fromUserPosition,
      fromUserCompany: updated.fromUserCompany,
      fromUserBio: updated.fromUserBio,
      fromUserBadges: updated.fromUserBadges,
      fromUserTotalBadges: updated.fromUserTotalBadges,
      toUserId: updated.toUserId,
      toUserName: updated.toUserName,
      toUserUsername: updated.toUserUsername,
      toUserEmail: updated.toUserEmail,
      toUserAvatar: updated.toUserAvatar,
      toUserPosition: updated.toUserPosition,
      toUserCompany: updated.toUserCompany,
      toUserBio: updated.toUserBio,
      toUserBadges: updated.toUserBadges,
      toUserTotalBadges: updated.toUserTotalBadges,
      message: updated.message,
      status: newStatus,
      preferredTime: updated.preferredTime,
      duration: updated.duration,
      collaborationNote: updated.collaborationNote,
      createdAt: updated.createdAt,
      updatedAt: DateTime.now(),
    );

    state.sent.refresh();
    state.received.refresh();
  }

  Future<void> acceptRequest({
    required String requestId,
    required String eventId,
    required int index,
    required bool isSent,
  }) async {
    if (!_canProceed(requestId)) return;

    try {
      final success = await ConnectionApi.respondToMeetingRequest(
        eventId: eventId,
        requestId: requestId,
        status: 'accepted',
      );

      if (success) {
        _updateRequestByIndex(
          isSent: isSent,
          index: index,
          requestId: requestId,
          newStatus: 'accepted',
        );

        AppSnackbar.success(
          title: 'Success',
          message: 'Meeting request accepted',
        );
      }
    } catch (err) {
      _handleError(err);
    } finally {
      _stopLoading(requestId);
    }
  }

  Future<void> rejectRequest({
    required String requestId,
    required String eventId,
    required int index,
    required bool isSent,
  }) async {
    if (!_canProceed(requestId)) return;

    try {
      final success = await ConnectionApi.respondToMeetingRequest(
        eventId: eventId,
        requestId: requestId,
        status: 'declined',
      );

      if (success) {
        _updateRequestByIndex(
          isSent: isSent,
          index: index,
          requestId: requestId,
          newStatus: 'declined',
        );

        AppSnackbar.success(
          title: 'Success',
          message: 'Meeting request declined',
        );
      }
    } catch (err) {
      _handleError(err);
    } finally {
      _stopLoading(requestId);
    }
  }

  Future<void> cancelRequest({
    required String requestId,
    required int index,
  }) async {
    if (!_canProceed(requestId)) return;

    try {
      final success = await ConnectionApi.cancelMeetingRequest(
        requestId: requestId,
      );

      if (success) {
        state.sent.value?.requests.removeAt(index);
        state.sent.refresh();

        AppSnackbar.success(
          title: 'Success',
          message: 'Meeting request cancelled',
        );
      }
    } catch (err) {
      _handleError(err);
    } finally {
      _stopLoading(requestId);
    }
  }

  void _handleError(dynamic err) {
    if (err is DioException) {
      final statusCode = err.response?.statusCode;
      if (statusCode == 401) {
        UserStore.to.clearStore();
        Get.offAllNamed('/sign-in');
        return;
      }
    }

    AppSnackbar.error(
      title: 'Failed',
      message: 'Something went wrong. Please try again.',
    );
  }

  @override
  void onClose() {
    sentScrollController.removeListener(_onSentScroll);
    receivedScrollController.removeListener(_onReceivedScroll);

    sentScrollController.dispose();
    receivedScrollController.dispose();

    _statusDebounceWorker.dispose();

    super.onClose();
  }
}
