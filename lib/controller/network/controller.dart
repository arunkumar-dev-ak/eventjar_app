import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_analytics_api/contact_analytics_api.dart';
import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/network/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkScreenController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "Network";
  final state = NetworkScreenState();
  DashboardController dashboardController = Get.find();

  late final TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    super.onInit();
  }

  void onTabOpen() {
    LoggerService.loggerInstance.dynamic_d("in on tab open");
    fetchContactAnalytics();
  }

  void changeTab(int index) {
    if (index != state.selectedTab.value) {
      state.selectedTab.value = index;
      update();
    }
  }

  Future<void> fetchContactAnalytics() async {
    state.isLoading.value = true;
    try {
      final result = await ContactAnalyticsApi.getAnalytics(
        '/contacts/analytics',
      );
      state.analytics.value = result;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to fetch analytics");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await fetchContactAnalytics();
      } else {
        dashboardController.state.selectedIndex.value = 0;
      }
    });
  }

  void navigateToContactPage(NetworkStatusCardData statusCard) {
    Get.toNamed(
      RouteName.contactPage,
      arguments: {'statusCard': statusCard, 'analytics': state.analytics.value},
    )?.then((_) async => {await fetchContactAnalytics()});
  }
}
