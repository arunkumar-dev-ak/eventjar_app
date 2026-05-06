import 'package:eventjar/controller/dashboard/state.dart';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (args != null && args is Map<String, dynamic>) {
        _handleNotificationNavigation(args);
      } else {
        state.selectedIndex.value = 0;
      }
    });
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
    } else if (index == 4) {
      state.selectedIndex.value = index;
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

  /*----- Notification and Deeplink Handling  -----*/
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
    final isLoginRequired = args["isLoginRequired"] == true;

    // If login required but NOT logged in → go to login first
    if (isLoginRequired && !isLoggedIn.value) {
      final result = await Get.toNamed(RouteName.signInPage);

      if (result == "logged_in") {
        // After login → continue navigation
        _resumeNotificationNavigation(args);
      }

      return;
    }

    _resumeNotificationNavigation(args);
  }

  Future<void> _resumeNotificationNavigation(Map<String, dynamic> args) async {
    final initialTab = args["initialTab"];

    if (initialTab != null) {
      state.selectedIndex.value = initialTab;

      await Future.delayed(const Duration(milliseconds: 300));

      await _openSubPage(args);
    }
  }

  Future<void> _openSubPage(Map<String, dynamic> args) async {
    final subPage = args["openSubPage"];

    switch (subPage) {
      case "contact":
        await Get.toNamed(
          RouteName.contactPage,
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "signUpPage":
        final token = args["token"];

        await Get.toNamed(
          RouteName.signUpPage,
          arguments: {"token": token},
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "eventInfo":
        await Get.toNamed(
          RouteName.eventInfoPage,
          parameters: args['parameters'],
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "meeting":
        await Get.toNamed(
          RouteName.meetingPage,
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "connection":
        final tab = args["connectionTab"] ?? 0;
        await Get.toNamed(
          RouteName.connectionPage,
          arguments: {"openTab": tab},
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      // NEWLY ADDED HANDLERS
      case "email_integration":
        await Get.toNamed(
          RouteName.notificationpage,
          arguments: "email",
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "whatsapp_integration":
        await Get.toNamed(
          RouteName.emailNotificationFormOage,
          arguments: "whatsapp",
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "calendar_feature":
        // await Get.toNamed(
        //   RouteName.calendarFeaturePage,
        // )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "scan_card":
        await Get.toNamed(
          RouteName.scanCardPage,
          arguments: {"enableTour": true},
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "add_contact":
        await Get.toNamed(
          RouteName.addContactPage,
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      case "overdue_contact":
        await Get.toNamed(
          RouteName.contactPage,
          arguments: {
            "statusCard": NetworkStatusCardData(
              key: 'overdue',
              enumKey: 'overdue',
              label: 'Overdue',
              icon: Icons.warning_amber_rounded,
              color: Colors.red,
            ),
          },
        )?.then((_) => _triggerTabController(state.selectedIndex.value));
        break;

      default:
        _triggerTabController(state.selectedIndex.value);
    }
  }
}
