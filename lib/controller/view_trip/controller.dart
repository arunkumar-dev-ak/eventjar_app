import 'package:dio/dio.dart';
import 'package:eventjar/api/budget_track_api/budget_track_api.dart';
import 'package:eventjar/api/view_trip_api/view_trip_api.dart';
import 'package:eventjar/controller/view_trip/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/expense_model.dart';
import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/route_name.dart';

class ViewTripController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "";
  final state = ViewTripState();

  late AnimationController animation;
  final expenseScrollController = ScrollController();
  final friendsScrollController = ScrollController();

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

    if (expenseScrollController.position.pixels >=
            expenseScrollController.position.maxScrollExtent - 200 &&
        hasExpenseMore) {
      fetchTripExpensesOnScroll();
    }
  }

  void _onFriendScroll() {
    if (state.selectedTab.value != 1) return;

    if (!friendsScrollController.hasClients) return;

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
    final meta = state.meta.value;

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

      // Future
      // await fetchTripFriends();
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

      await fetchTripExpenses();

      // Future
      // await fetchTripFriends();
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
      state.meta.value = response.meta;
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

      state.meta.value = response.meta;
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

  void toggleToOpen(int index) {
    if (state.expenseOpenedIndex.value == index) {
      state.expenseOpenedIndex.value = -1;
    } else {
      state.expenseOpenedIndex.value = index;
    }
  }

  void toggleToSelect(int index) {
    if (state.expenseSelectedIndexes.contains(index)) {
      state.expenseSelectedIndexes.remove(index);
    } else {
      state.expenseSelectedIndexes.add(index);
    }
    state.showLongPressHint.value = false;
  }

  void dismissLongPressHint() {
    state.showLongPressHint.value = false;
  }

  void clearSelection() {
    state.expenseSelectedIndexes.clear();
  }

  double get yourSpent {
    double total = 0;
    // for (final e in state.expense) {
    //   total += e.yourShare;
    // }
    return total;
  }

  Map<String, double> get _perPersonBalances {
    final Map<String, double> balances = {};
    // for (final e in state.expense) {
    //   final isYou = e.paidBy == "You";
    //   final splitCount = e.members.isNotEmpty
    //       ? e.members.length
    //       : (e.yourShare > 0 ? (e.amount / e.yourShare).round() : 1);
    //   final perPerson = e.amount / splitCount;
    //   if (isYou) {
    //     for (final m in e.members) {
    //       if (m == "You") continue;
    //       balances[m] = (balances[m] ?? 0) + perPerson;
    //     }
    //   } else {
    //     balances[e.paidBy] = (balances[e.paidBy] ?? 0) - perPerson;
    //   }
    // }
    return balances;
  }

  double get youOwe {
    double total = 0;
    for (final net in _perPersonBalances.values) {
      if (net < 0) total += net.abs();
    }
    return total;
  }

  double get youReceive {
    double total = 0;
    for (final net in _perPersonBalances.values) {
      if (net > 0) total += net;
    }
    return total;
  }

  void deleteExpense(int index) {
    // final sortedExpenses = [...state.expense]
    //   ..sort((a, b) => b.date.compareTo(a.date));
    // if (index < 0 || index >= sortedExpenses.length) return;
    // final expense = sortedExpenses[index];
    // state.expense.remove(expense);
  }

  void changeTab(int index) {
    if (state.selectedTab.value != index &&
        state.expenseSelectedIndexes.isNotEmpty) {
      state.expenseSelectedIndexes.clear();
    }
    state.selectedTab.value = index;
    if (pageController.hasClients && pageController.page?.round() != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageSwiped(int index) {
    if (state.selectedTab.value == index) return;
    if (state.expenseSelectedIndexes.isNotEmpty) {
      state.expenseSelectedIndexes.clear();
    }
    state.selectedTab.value = index;
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

    expenseScrollController.dispose();
    friendsScrollController.dispose();
  }
}
