import 'package:dio/dio.dart';
import 'package:eventjar/api/notification_api/notification_api.dart';
import 'package:eventjar/controller/notification/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/notification/email_providers.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var state = NotificationState();

  @override
  void onInit() {
    super.onInit();
    loadEmailProviders();
  }

  Future<void> loadEmailProviders() async {
    try {
      state.isLoading.value = true;
      final providers = await NotificationApi.getEmailProviders();
      final emailConfig = await NotificationApi.getEmailConfig();
      state.providers.value = providers.providers;
      state.emailConfig.value = emailConfig;
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to fetch Email Configuration");
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

  Future<void> disconnectEmail() async {
    try {
      state.isDeleting.value = true;
      await NotificationApi.deleteEmailConfig();
      AppSnackbar.success(
        title: "Disconnection Success",
        message: "Email Configuration disconnected successfully.",
      );
      loadEmailProviders();
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(
          err,
          "Failed to Disconnect Email Configuration",
        );
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isDeleting.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        loadEmailProviders();
      }
    });
  }

  void navigateToEmailNotification(EmailProvider provider) {
    Get.toNamed(RouteName.emailNotificationFormOage, arguments: provider)?.then(
      (result) async {
        // if (result == "refresh") {
        loadEmailProviders();
        // }
      },
    );
  }

  void changeTab(int index) async {
    if (state.selectedTab.value == index) return;
    state.selectedTab.value = index;
    if (index == 0) {
      await loadEmailProviders();
    }

    if (index == 1) {
      // await fetchConnections();
    }
  }
}
