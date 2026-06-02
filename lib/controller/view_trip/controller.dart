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
  late PageController pageController;

  static const _limit = 10;

  @override
  void onInit() {
    super.onInit();

    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    pageController = PageController(initialPage: state.selectedTab.value);

    final args = Get.arguments;

    if (args is TripModel) {
      state.trip.value = args;
      state.tripId.value = args.id;
    }

    fetchTripAnalytics();
    fetchTripExpenses();
  }

  //pagination helpers
  int _getLimit() {
    return _limit;
  }

  int _getExpenseNextOffset() {
    return state.expenses.length;
  }

  bool get hasExpenseMore {
    final meta = state.meta.value;

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

  //trip analytics
  Future<void> fetchTripAnalytics() async {
    try {
      final response = await BudgetTrackApi.getTrips(
        queryParams: {'tripId': state.tripId.value, 'limit': 1},
      );

      if (response.data.isNotEmpty) {
        state.trip.value = response.data.first;
      }
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
    }
  }

  /*-----Trip Expense -----*/
  Future<void> fetchTripExpenses() async {
    try {
      state.isLoading.value = true;

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
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> refreshTripExpenses() async {
    if (state.isPaginationLoading.value) {
      return;
    }

    try {
      await fetchTripAnalytics();

      final response = await ViewTripApi.getTripExpenses(
        queryParams: getExpenseQueryParams(onRefresh: true),
      );

      state.expenses.value = response.data;
      state.meta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Expense refresh error: $err');

      ApiErrorHandler.handle(
        error: err,
        title: "Failed to Refresh Expense",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    }
  }

  Future<void> fetchTripExpensesOnScroll() async {
    if (state.isPaginationLoading.value || !hasExpenseMore) {
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
    pageController.dispose();
    super.onClose();
  }
}
