import 'package:eventjar/controller/budget_track/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BudgetTrackController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final state = BudgetTrackState();

  late TabController tabController;

  final tabs = const [
    "Friends",
    "Trips",
    "Expenses",
    "Balances",
    "Transactions",
  ];

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        final index = tabController.index;

        state.selectedMainTab.value = index;

        _handleTabChange(index);
      }
    });

    super.onInit();
  }

  void _handleTabChange(int index) {
    switch (index) {
      case 0:
        fetchFriends();
        break;
      case 1:
        fetchTrips();
        break;
      case 2:
        fetchExpenses();
        break;
      case 3:
        fetchBalances();
        break;
      case 4:
        fetchSettlements();
        break;
    }
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

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
