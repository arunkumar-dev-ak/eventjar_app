import 'package:eventjar/controller/network/state.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkScreenController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "Network";
  final state = NetworkScreenState();

  late final TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    super.onInit();
  }

  void changeTab(int index) {
    if (index != state.selectedTab.value) {
      state.selectedTab.value = index;
      update();
    }
  }

  void navigateToContactPage(dynamic tab) {
    Get.toNamed(RouteName.contactPage, arguments: tab);
  }
}
