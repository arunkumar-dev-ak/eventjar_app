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
    fetchContactAnalytics();
  }

  final List<NetworkStatusCardData> statusCards = [
    NetworkStatusCardData(
      key: 'totalContacts',
      label: 'Total Contacts',
      icon: Icons.people,
      color: Colors.blue,
    ),
    NetworkStatusCardData(
      key: 'new',
      label: 'New',
      icon: Icons.fiber_new,
      color: Colors.green,
    ),
    NetworkStatusCardData(
      key: 'followup24h',
      label: '24H Followup',
      icon: Icons.access_time,
      color: Colors.orange,
    ),
    NetworkStatusCardData(
      key: 'followup7d',
      label: '7D Followup',
      icon: Icons.calendar_view_week,
      color: Colors.purple,
    ),
    NetworkStatusCardData(
      key: 'followup30d',
      label: '30D Followup',
      icon: Icons.calendar_month,
      color: Colors.teal,
    ),
    NetworkStatusCardData(
      key: 'qualified',
      label: 'Qualified',
      icon: Icons.verified,
      color: Colors.indigo,
    ),
    NetworkStatusCardData(
      key: 'overdue',
      label: 'Overdue',
      icon: Icons.warning_amber_rounded,
      color: Colors.red,
    ),
  ];

  int getCountByKey(ContactAnalytics? analytics, String key) {
    if (analytics == null) return 0;

    switch (key) {
      case 'totalContacts':
        return analytics.total;
      case 'new':
        return analytics.newCount;
      case 'followup24h':
        return analytics.followup24h;
      case 'followup7d':
        return analytics.followup7d;
      case 'followup30d':
        return analytics.followup30d;
      case 'qualified':
        return analytics.qualified;
      case 'overdue':
        return analytics.overdue;
      default:
        return 0;
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
        LoggerService.loggerInstance.dynamic_d("in back");
        // dashboardController.state.selectedIndex.value = 0;
        Get.offAllNamed(RouteName.dashboardpage);
      }
    });
  }

  void navigateToContactPage(NetworkStatusCardData statusCard) {
    Get.toNamed(
      RouteName.contactPage,
      arguments: {'statusCard': statusCard, 'analytics': state.analytics.value},
    )?.then((_) async => {await fetchContactAnalytics()});
  }

  void onConnectionTap() {
    Get.toNamed(RouteName.connectionPage);
  }

  void onSchedulerTap() {
    // open scheduler UI
  }

  void onReminderTap() {
    // open reminders UI
  }
}
