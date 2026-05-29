import 'package:eventjar/controller/view_trip/state.dart';
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

  @override
  void onInit() {
    super.onInit();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    pageController = PageController(initialPage: state.selectedTab.value);
    state.trip.value = Get.arguments as TripModel;
    state.friends.value = dummyTripFriends[state.trip.value.title] ?? [];
    LoggerService.loggerInstance.dynamic_d(state.friends.value);
    state.expense.value = dummyTripExpenses[state.trip.value.title] ?? [];

    appBarTitle = state.trip.value.title;
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
    for (final e in state.expense) {
      total += e.yourShare;
    }
    return total;
  }

  Map<String, double> get _perPersonBalances {
    final Map<String, double> balances = {};
    for (final e in state.expense) {
      final isYou = e.paidBy == "You";
      final splitCount = e.members.isNotEmpty
          ? e.members.length
          : (e.yourShare > 0 ? (e.amount / e.yourShare).round() : 1);
      final perPerson = e.amount / splitCount;
      if (isYou) {
        for (final m in e.members) {
          if (m == "You") continue;
          balances[m] = (balances[m] ?? 0) + perPerson;
        }
      } else {
        balances[e.paidBy] = (balances[e.paidBy] ?? 0) - perPerson;
      }
    }
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
    final sortedExpenses = [...state.expense]
      ..sort((a, b) => b.date.compareTo(a.date));
    if (index < 0 || index >= sortedExpenses.length) return;
    final expense = sortedExpenses[index];
    state.expense.remove(expense);
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
