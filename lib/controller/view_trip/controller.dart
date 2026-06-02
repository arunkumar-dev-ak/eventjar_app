import 'package:eventjar/api/budget_track_api/budget_track_api.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/api/split_track_api/split_track_api.dart';
import 'package:eventjar/api/view_trip_api/view_trip_api.dart';
import 'package:eventjar/controller/view_trip/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
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

  late AnimationController animation;
  final pageController = PageController();
  final expenseScrollController = ScrollController();
  final friendsScrollController = ScrollController();

  final settleAmountController = TextEditingController();
  final settleNotesController = TextEditingController();

  static const _limit = 10;

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
        title: "Failed to Get Trip Analytics",
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
        title: "Failed to load Expenses",
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
        title: "Failed to load more expense",
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
        title: "Failed to load Friends",
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
      LoggerService.loggerInstance.dynamic_d("reee ${response.data.length}");

      state.friends.value = response.data;
      state.friendMeta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Friend refresh error: $err');

      ApiErrorHandler.handle(
        error: err,
        title: "Failed to refresh Friends",
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
        title: "Failed to load more Friends",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isFriendPaginationLoading.value = false;
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
        title: "Success",
        message: "Settlement marked successfully",
      );

      Navigator.pop(Get.context!);

      await fetchViewFriendData();
    } catch (err) {
      LoggerService.loggerInstance.e('Settlement error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "Unable to Complete Settlement",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isSettleupLoading.value = false;
    }
  }

  void deleteExpense(int index) {
    // final sortedExpenses = [...state.expense]
    //   ..sort((a, b) => b.date.compareTo(a.date));
    // if (index < 0 || index >= sortedExpenses.length) return;
    // final expense = sortedExpenses[index];
    // state.expense.remove(expense);
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
    Get.toNamed(RouteName.createExpensePage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
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
