import 'package:eventjar/controller/view_trip/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/route_name.dart';

class ViewTripController extends GetxController
    with GetSingleTickerProviderStateMixin {
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

  void changeTab(int index) {
    if (state.selectedTab.value != index &&
        state.expenseSelectedIndexes.isNotEmpty) {
      state.expenseSelectedIndexes.clear();
    }
    state.selectedTab.value = index;
    if (pageController.hasClients &&
        pageController.page?.round() != index) {
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
    LoggerService.loggerInstance.dynamic_d("In Onclose");
    animation.dispose();
    pageController.dispose();
    super.onClose();
  }
}
