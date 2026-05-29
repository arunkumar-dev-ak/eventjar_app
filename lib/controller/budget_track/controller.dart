import 'package:eventjar/controller/budget_track/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/expense_model.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetTrackController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final state = BudgetTrackState();
  late AnimationController animation;

  @override
  void onInit() {
    super.onInit();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void toggleNotes(int index) {
    state.expandedNotes[index] = !(state.expandedNotes[index] ?? false);
  }

  bool isExpanded(int index) {
    return state.expandedNotes[index] ?? false;
  }

  Map<String, String> getHeader(int index) {
    switch (index) {
      case 0:
        return {"title": "Friends", "subtitle": "Manage your social circle"};
      case 1:
        return {"title": "Trips", "subtitle": "Manage your social circle"};
      case 2:
        return {"title": "Expenses", "subtitle": "Manage and split trip costs"};
      case 3:
        return {
          "title": "Balances",
          "subtitle": "Track your shared expenses and settle up",
        };
      case 4:
        return {
          "title": "Transactions",
          "subtitle": "View and manage all your payment activity",
        };
      default:
        return {"title": "", "subtitle": ""};
    }
  }

  Map<String, double> computeTripAnalytics(String tripTitle) {
    final expenses = dummyTripExpenses[tripTitle] ?? [];
    double yourSpent = 0;
    final Map<String, double> balances = {};

    for (final e in expenses) {
      final isYou = e.paidBy == "You";
      yourSpent += e.yourShare;

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

    double youOwe = 0;
    double youReceive = 0;
    for (final net in balances.values) {
      if (net > 0) {
        youReceive += net;
      } else {
        youOwe += net.abs();
      }
    }

    return {'yourSpent': yourSpent, 'youOwe': youOwe, 'youReceive': youReceive};
  }

  int getExpenseCount(String tripTitle) {
    return (dummyTripExpenses[tripTitle] ?? []).length;
  }

  /*----- Balances Tab ------*/
  void selectOwed() {
    state.isOwedSelected.value = true;
  }

  void selectOwe() {
    state.isOwedSelected.value = false;
  }

  // MOCK API METHODS
  void fetchFriends() {
    LoggerService.loggerInstance.dynamic_d("Fetching Friends...");
  }

  void fetchTrips() {
    LoggerService.loggerInstance.dynamic_d("Fetching Trips...");
  }

  void fetchExpenses() {
    LoggerService.loggerInstance.dynamic_d("Fetching Expenses...");
  }

  void fetchBalances() {
    LoggerService.loggerInstance.dynamic_d("Fetching Balances...");
  }

  void fetchSettlements() {
    LoggerService.loggerInstance.dynamic_d("Fetching Settle Ups...");
  }

  //navigation
  void navigateToFriendList() {
    Get.toNamed(RouteName.friendListPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToTransaction() {
    Get.toNamed(RouteName.transactionPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToCreateTrip() {
    Get.toNamed(RouteName.createTripPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
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

  void navigateToViewTrip(TripModel trip) {
    Get.toNamed(
      RouteName.viewTripPage,
      arguments: trip,
    )?.then((result) async {});
  }

  @override
  void onClose() {
    animation.dispose();
    super.onClose();
  }
}
