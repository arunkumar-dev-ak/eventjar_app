import 'package:eventjar/controller/dashboard/state.dart';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var appBarTitle = "EventJar";
  final state = DashboardState();
  DateTime lastBackPressed = DateTime.now();

  RxBool get isLoggedIn => UserStore.to.isLoginReactive;
  RxMap<String, dynamic> get profile => UserStore.to.profile;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args is Map<String, dynamic>) {
      _handleNotificationNavigation(args);
    } else {
      state.selectedIndex.value = 0;
    }
  }

  bool shouldExit() {
    final now = DateTime.now();
    final difference = now.difference(lastBackPressed);

    if (difference > const Duration(seconds: 2)) {
      lastBackPressed = now;
      return false;
    }
    return true;
  }

  void popAndMoveToTicketPage() {
    state.selectedIndex.value = 3;
    MyTicketController ticketController = Get.find();
    ticketController.onTabOpen();

    Get.until((route) => route.settings.name == RouteName.dashboardpage);
  }

  void changeTab(int index) {
    if (index == state.selectedIndex.value) return;
    if (index == 0) {
      state.selectedIndex.value = index;
      Get.find<HomeController>().onTabOpen();
    } else if (index == 1 && isLoggedIn.value == true) {
      state.selectedIndex.value = index;
      Get.find<NetworkScreenController>().onTabOpen();
    } else if (index == 2 && isLoggedIn.value == true) {
      state.selectedIndex.value = index;
      Get.find<UserProfileController>().onTabOpen();
    } else if (index == 3 && isLoggedIn.value == true) {
      state.selectedIndex.value = index;
      Get.find<MyTicketController>().onTabOpen();
    } else if (index == 4 && isLoggedIn.value == true) {
      Get.toNamed(RouteName.budgetTrackPage);
    } else {
      navigateToSignInPage(index);
    }
  }

  void navigateToSignInPage(int index) {
    LoggerService.loggerInstance.dynamic_d(index);
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        state.selectedIndex.value = index;
        if (index == 1) {
          Get.find<NetworkScreenController>().onTabOpen();
        } else if (index == 2) {
          Get.find<UserProfileController>().onTabOpen();
        } else if (index == 3) {
          Get.find<MyTicketController>().onTabOpen();
        }
      }
    });
  }

  /*----- Notification Handling  -----*/
  void _triggerTabController(int index) {
    if (index == 1) {
      Get.find<NetworkScreenController>().onTabOpen();
    } else if (index == 2) {
      Get.find<UserProfileController>().onTabOpen();
    } else if (index == 3) {
      Get.find<MyTicketController>().onTabOpen();
    }
  }

  Future<void> _handleNotificationNavigation(Map<String, dynamic> args) async {
    final initialTab = args["initialTab"];
    final isLoginRequired = args["isLoginRequired"] == true;

    if (((isLoginRequired && isLoggedIn.value) || !isLoginRequired) &&
        initialTab != null) {
      state.selectedIndex.value = initialTab;

      //small delay
      await Future.delayed(const Duration(milliseconds: 300));

      // open Notification page
      await _openSubPage(args);
    }
  }

  Future<void> _openSubPage(Map<String, dynamic> args) async {
    final subPage = args["openSubPage"];

    if (subPage == "contact") {
      await Get.toNamed(
        RouteName.contactPage,
      )?.then((_) => {_triggerTabController(state.selectedIndex.value)});
    } else if (subPage == "meeting") {
      await Get.toNamed(
        RouteName.meetingPage,
      )?.then((_) => {_triggerTabController(state.selectedIndex.value)});
    } else if (subPage == "connection") {
      final tab = args["connectionTab"] ?? 0;

      await Get.toNamed(
        RouteName.connectionPage,
        arguments: {"openTab": tab},
      )?.then((_) => {_triggerTabController(state.selectedIndex.value)});
    } else {
      _triggerTabController(state.selectedIndex.value);
    }
  }
}
