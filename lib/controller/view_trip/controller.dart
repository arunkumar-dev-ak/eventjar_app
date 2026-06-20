import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/budget_track_api/budget_track_api.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/api/view_trip_api/view_trip_api.dart';
import 'package:eventjar/controller/view_trip/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/model/view_trip/dropdown_friend_model.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';
import 'package:eventjar/page/view_trip/friends/friend_settleup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/route_name.dart';

enum PaymentActionType { settleUp, record }

class ViewTripController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "";
  final state = ViewTripState();

  Timer? _friendSearchDebounce;

  late AnimationController animation;
  final pageController = PageController();
  final expenseScrollController = ScrollController();
  final friendsScrollController = ScrollController();

  final settleAmountController = TextEditingController();
  final settleNotesController = TextEditingController();

  static const _limit = 15;

  Timer? _friendSearchDebounceTimer;

  @override
  void onInit() {
    super.onInit();

    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final args = Get.arguments;

    if (args is TripModel) {
      state.trip.value = args;
      state.tripId.value = args.id;
    }

    expenseScrollController.addListener(_onExpenseScroll);
    friendsScrollController.addListener(_onFriendScroll);

    fetchViewTripData();
  }

  // scroll controller
  void _onExpenseScroll() {
    if (state.selectedTab.value != 0) return;

    if (!expenseScrollController.hasClients) return;

    if (state.selectedTab.value == 0 &&
        expenseScrollController.position.pixels >=
            expenseScrollController.position.maxScrollExtent - 200 &&
        hasExpenseMore) {
      fetchTripExpensesOnScroll();
    }
  }

  void _onFriendScroll() {
    if (state.selectedTab.value != 1) return;

    if (!friendsScrollController.hasClients) return;

    if (state.selectedTab.value == 1 &&
        friendsScrollController.position.pixels >=
            friendsScrollController.position.maxScrollExtent - 200 &&
        hasFriendMore) {
      fetchTripFriendsOnScroll();
    }

    // if (hasFriendMore) {
    //   fetchTripFriendsOnScroll();
    // }
  }

  //pagination helpers
  int _getLimit() {
    return _limit;
  }

  int _getExpenseNextOffset() {
    return state.expenses.length;
  }

  int _getFriendNextOffset() {
    return state.friends.length;
  }

  bool get hasExpenseMore {
    final meta = state.expenseMeta.value;

    if (meta == null) {
      return true;
    }

    return meta.paging.pages.next != null;
  }

  bool get hasFriendMore {
    final meta = state.friendMeta.value;

    if (meta == null) {
      return true;
    }

    return meta.paging.pages.next != null;
  }

  Map<String, dynamic> getExpenseQueryParams({bool onRefresh = false}) {
    return {
      'tripId': state.tripId.value,
      'offset': onRefresh ? 0 : _getExpenseNextOffset(),
      'limit': _getLimit(),
    };
  }

  Map<String, dynamic> getFriendQueryParams({bool onRefresh = false}) {
    return {
      'tripId': state.tripId.value,
      'offset': onRefresh ? 0 : _getFriendNextOffset(),
      'limit': _getLimit(),
    };
  }

  Future<void> fetchViewTripData({bool onRefresh = false}) async {
    try {
      if (!onRefresh) state.isLoading.value = true;

      final analyticsLoaded = await fetchTripAnalytics();

      if (!analyticsLoaded) {
        return;
      }

      await fetchTripExpenses();
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> fetchViewFriendData({bool onRefresh = false}) async {
    try {
      if (!onRefresh) state.isLoading.value = true;

      final analyticsLoaded = await fetchTripAnalytics();

      if (!analyticsLoaded) {
        return;
      }

      await fetchTripFriends();
      state.isFriendsLoaded.value = true;
    } finally {
      state.isLoading.value = false;
    }
  }

  //trip analytics
  Future<bool> fetchTripAnalytics() async {
    try {
      final response = await BudgetTrackApi.getTrips(
        queryParams: {'tripId': state.tripId.value, 'limit': 1},
      );

      if (response.data.isNotEmpty) {
        state.trip.value = response.data.first;
      }
      return true;
    } catch (err) {
      LoggerService.loggerInstance.e('Trip Loads onScroll error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "failed_get_trip_analytics".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
      return false;
    }
  }

  /*-----Trip Expense -----*/
  Future<void> fetchTripExpenses() async {
    try {
      final response = await ViewTripApi.getTripExpenses(
        queryParams: {
          'tripId': state.tripId.value,
          'offset': 0,
          'limit': _limit,
        },
      );

      state.expenses.value = response.data;
      state.expenseMeta.value = response.meta;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_expenses".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    }
  }

  Future<void> refreshTripExpenses() async {
    await fetchViewTripData(onRefresh: true);
  }

  Future<void> fetchTripExpensesOnScroll() async {
    if (state.isPaginationLoading.value) {
      return;
    }

    try {
      state.isPaginationLoading.value = true;

      final response = await ViewTripApi.getTripExpenses(
        queryParams: getExpenseQueryParams(),
      );

      state.expenses.addAll(response.data);

      state.expenseMeta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Expense onScroll error: $err');

      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_more_expense".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isPaginationLoading.value = false;
    }
  }

  /*----- Trip Friends -----*/
  Future<void> fetchTripFriends() async {
    try {
      final response = await ViewTripApi.getTripFriends(
        queryParams: {
          'tripId': state.tripId.value,
          'offset': 0,
          'limit': _limit,
        },
      );

      state.friends.value = response.data;
      state.friendMeta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Friend load error: $err');

      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_friends".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    }
  }

  Future<void> refreshTripFriends() async {
    if (state.isFriendPaginationLoading.value) {
      return;
    }

    try {
      final response = await ViewTripApi.getTripFriends(
        queryParams: getFriendQueryParams(onRefresh: true),
      );

      state.friends.value = response.data;
      state.friendMeta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Friend refresh error: $err');

      ApiErrorHandler.handle(
        error: err,
        title: "failed_refresh_friends".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    }
  }

  Future<void> fetchTripFriendsOnScroll() async {
    if (state.isFriendPaginationLoading.value || !hasFriendMore) {
      return;
    }

    try {
      state.isFriendPaginationLoading.value = true;

      final response = await ViewTripApi.getTripFriends(
        queryParams: getFriendQueryParams(),
      );

      state.friends.addAll(response.data);

      state.friendMeta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Friend pagination error: $err');

      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_more_friends".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isFriendPaginationLoading.value = false;
    }
  }

  //delete Expense
  Future<bool> closeExpenseRequest(String expenseId) async {
    try {
      state.deleteExpenseLoading.value = true;
      await ViewTripApi.deleteExpense(expenseId);

      AppSnackbar.success(
        title: "success".tr,
        message: "expense_request_closed".tr,
      );

      fetchViewTripData();
      return true;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_close_expense".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
      return false;
    } finally {
      state.deleteExpenseLoading.value = false;
    }
  }

  //settlement dialog
  void openPaymentDialog(TripFriendModel friend, PaymentActionType type) {
    settleAmountController.text = type == PaymentActionType.record
        ? friend.myReceive.abs().toStringAsFixed(0)
        : friend.myOwe.abs().toStringAsFixed(0);

    settleNotesController.clear();
    state.paymentMethod.value = 'UPI';

    Get.dialog(SettleUpDialog(friend: friend, type: type));
  }

  Future<void> submitSettleUp(
    TripFriendModel friend,
    PaymentActionType type,
  ) async {
    final rawAmount = settleAmountController.text.trim();
    final double amount = double.tryParse(rawAmount) ?? 0;

    try {
      state.isSettleupLoading.value = true;

      final payload = {
        "toMemberId": friend.memberId,
        "tripId": state.tripId.value,
        "amount": type == PaymentActionType.record ? amount : -amount,
        "method": state.paymentMethod.value.toLowerCase().replaceAll(" ", "_"),
        "notes": settleNotesController.text.trim(),
      };

      await ViewTripApi.settleBalance(data: payload);

      AppSnackbar.success(
        title: "success".tr,
        message: "settlement_marked_success".tr,
      );

      Navigator.pop(Get.context!);

      await fetchViewFriendData();
    } catch (err) {
      LoggerService.loggerInstance.e('Settlement error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "unable_complete_settlement".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isSettleupLoading.value = false;
    }
  }

  void getDropdownFriendList() {
    state.isFriendDropdownLoading.value = true;
    state.currentFriendSearchQuery.value = ''; // Reset search

    try {
      ViewTripApi.getDropdownFriends(
            tripId: state.tripId.value,
            limit: _limit,
            offset: 0,
          )
          .then((DropdownFriendResponseModel response) {
            state.dropdownFriends.value = response.data;
            state.friendDropdownMeta.value = response.meta;
          })
          .onError((error, stackTrace) {
            _handleApiError(error, 'Failed to load friends');
          })
          .whenComplete(() {
            state.isFriendDropdownLoading.value = false;
          });
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      state.isFriendDropdownLoading.value = false;
      AppSnackbar.error(title: 'error'.tr, message: 'failed_load_contacts'.tr);
    }
  }

  //
  //---------------------------------------------------------------------------
  // 2. ON SEARCH CHANGED
  // ---------------------------------------------------------------------------
  void onFriendSearchChanged(String? val) {
    if (state.isFriendDropdownLoading.value) return;

    final String query = val?.trim() ?? '';
    state.currentFriendSearchQuery.value = query;

    // Cancel previous debounce
    if (_friendSearchDebounceTimer?.isActive ?? false) {
      _friendSearchDebounceTimer?.cancel();
    }

    state.isFriendDropdownLoading.value = true;

    _friendSearchDebounceTimer = Timer(const Duration(milliseconds: 800), () {
      try {
        ViewTripApi.getDropdownFriends(
              tripId: state.tripId.value,
              search: query, // Pass the search query directly
              limit: _limit,
              offset: 0, // Reset offset to 0 for a new search
            )
            .then((DropdownFriendResponseModel response) {
              state.dropdownFriends.value = response.data;
              state.friendDropdownMeta.value = response.meta;
            })
            .onError((error, stackTrace) {
              _handleApiError(error, 'search_failed'.tr);
            })
            .whenComplete(() {
              state.isFriendDropdownLoading.value = false;
            });
      } catch (e) {
        LoggerService.loggerInstance.e(e);
        state.isFriendDropdownLoading.value = false;
        AppSnackbar.error(title: 'error'.tr, message: 'search_failed'.tr);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // 3. LOAD MORE (PAGINATION)
  // ---------------------------------------------------------------------------
  void onFriendLoadMoreClicked() {
    if (state.isFriendDropdownLoadMoreLoading.value) return;

    final totalCount = state.friendDropdownMeta.value?.paging?.totalCount ?? 0;
    final currentCount = state.dropdownFriends.length;

    if (currentCount >= totalCount) return; // Stop if we've loaded everything

    state.isFriendDropdownLoadMoreLoading.value = true;

    try {
      final int nextOffset = currentCount;

      ViewTripApi.getDropdownFriends(
            tripId: state.tripId.value,
            search: state
                .currentFriendSearchQuery
                .value, // Keep current search active
            limit: _limit,
            offset: nextOffset,
          )
          .then((DropdownFriendResponseModel response) {
            state.dropdownFriends.addAll(response.data);
            state.friendDropdownMeta.value = response.meta;
          })
          .onError((error, stackTrace) {
            _handleApiError(error, 'Load more failed');
          })
          .whenComplete(() {
            state.isFriendDropdownLoadMoreLoading.value = false;
          });
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      state.isFriendDropdownLoadMoreLoading.value = false;
      AppSnackbar.error(title: 'error'.tr, message: 'failed_load_more'.tr);
    }
  }

  // ---------------------------------------------------------------------------
  // 4. ON REFRESH CLICKED
  // ---------------------------------------------------------------------------
  void onFriendRefreshClicked() {
    state.isFriendDropdownLoading.value = true;
    state.isFriendDropdownLoadMoreLoading.value = false;

    try {
      ViewTripApi.getDropdownFriends(
            tripId: state.tripId.value,
            search: state
                .currentFriendSearchQuery
                .value, // Keep current search active
            limit: _limit,
            offset: 0, // Reset to page 1
          )
          .then((DropdownFriendResponseModel response) {
            state.dropdownFriends.value = response.data;
            state.friendDropdownMeta.value = response.meta;
          })
          .onError((error, stackTrace) {
            _handleApiError(error, 'Refresh failed');
          })
          .whenComplete(() {
            state.isFriendDropdownLoading.value = false;
          });
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      state.isFriendDropdownLoading.value = false;
      AppSnackbar.error(title: 'error'.tr, message: 'failed_refresh'.tr);
    }
  }

  // ---------------------------------------------------------------------------
  // ERROR HANDLER HELPER
  // ---------------------------------------------------------------------------
  void _handleApiError(Object? error, String fallbackMessage) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        UserStore.to.clearStore();
        Get.offAllNamed(RouteName.signInPage);
        return;
      }
      ApiErrorHandler.handleDioError(error, fallbackMessage);
    } else {
      AppSnackbar.error(title: 'error'.tr, message: fallbackMessage);
    }
  }

  Future<void> addSelectedFriendToTrip(
    DropDownFriendListModel selectedFriend,
  ) async {
    // Prevent multiple rapid clicks
    if (state.isAddingMember.value) return;

    final tripId = state.tripId.value;
    if (tripId.isEmpty) return;

    try {
      state.isAddingMember.value = true;

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      // 2. Call the API
      await ViewTripApi.addMemberToTrip(
        tripId: tripId,
        friendId: selectedFriend.id,
      );

      // 3. Close the global loading overlay
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // 4. Show Success Snackbar
      final currentUserId = UserStore.to.profile['id'] as String;
      final friendName = selectedFriend.getFriendDisplayName(currentUserId);

      AppSnackbar.success(
        title: 'success'.tr,
        message: 'friend_added_to_trip_success'.tr,
      );

      onFriendRefreshClicked();
      refreshTripFriends();
    } catch (error) {
      // Close the loading overlay on error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      LoggerService.loggerInstance.e(error);
      _handleApiError(error, 'Failed to add member to the trip.');
    } finally {
      state.isAddingMember.value = false;
    }
  }

  void changeTab(int index) {
    // if (state.selectedTab.value != index &&
    //     state.expenseSelectedIndexes.isNotEmpty) {
    //   state.expenseSelectedIndexes.clear();
    // }
    state.selectedTab.value = index;
    if (pageController.hasClients && pageController.page?.round() != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
    _loadDataForTab(index);
  }

  void onPageSwiped(int index) {
    if (state.selectedTab.value == index) return;
    if (state.expenseSelectedIndexes.isNotEmpty) {
      state.expenseSelectedIndexes.clear();
    }
    state.selectedTab.value = index;
    _loadDataForTab(index);
  }

  void _loadDataForTab(int index) {
    if (index == 0) {
      fetchViewTripData();
    } else {
      fetchViewFriendData();
    }
  }

  //navigation
  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await fetchTripExpenses();
      } else {
        Get.back();
      }
    });
  }

  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) async {
      // if (result == "logged_in") {
      //   // await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToCreateExpense() {
    Get.toNamed(
      RouteName.createExpensePage,
      arguments: {'tripId': state.tripId.value},
    )?.then((result) async {
      if (result == "refresh") {
        await fetchViewTripData();
      }
    });
  }

  void navigateToExpenseDetailPage(TripExpenseModel expense, int index) {
    Get.toNamed(
      RouteName.expenseDetailPage,
      arguments: {'expense': expense, 'index': index},
    );
  }

  void updateExpenseSafely(TripExpenseModel updatedExpense, int index) {
    if (index >= 0 && index < state.expenses.length) {
      if (state.expenses[index].id == updatedExpense.id) {
        if (state.expenses[index].title != updatedExpense.title) {
          state.expenses[index] = updatedExpense;
        }
        return;
      }
    }
  }

  Future<bool> removeMemberFromTrip(String memberId) async {
    final tripId = state.tripId.value;
    if (tripId.isEmpty) return false;

    state.isRemovingMember.value = true;

    try {
      // 1. Call the API
      await ViewTripApi.deleteMemberToTrip(tripId: tripId, memberId: memberId);

      // 2. Show Success Snackbar
      AppSnackbar.success(
        title: 'success'.tr,
        message: 'member_removed_from_trip'.tr,
      );

      // 3. Refresh the Friends list and Analytics to reflect the removal
      refreshTripFriends();

      return true;
    } catch (error) {
      LoggerService.loggerInstance.e(error);
      _handleApiError(error, 'Failed to remove member.');
      return false;
    } finally {
      state.isRemovingMember.value = false;
    }
  }

  @override
  void onClose() {
    animation.dispose();
    pageController.dispose();
    expenseScrollController.dispose();
    friendsScrollController.dispose();
    super.onClose();
  }
}
