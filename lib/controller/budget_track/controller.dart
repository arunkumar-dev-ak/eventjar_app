import 'package:eventjar/controller/budget_track/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BudgetTrackController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final state = BudgetTrackState();

  late TabController tabController;

  final tabs = const ["Friends", "Trips", "Expenses", "Balances", "Settle Ups"];

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

  /// MOCK API METHODS
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

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
