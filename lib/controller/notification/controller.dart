import 'package:dio/dio.dart';
import 'package:eventjar/api/notification_api/notification_api.dart';
import 'package:eventjar/api/whatsapp_integration_api/whatsapp_integration_api.dart';
import 'package:eventjar/controller/notification/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/notification/email_providers.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationController extends GetxController {
  var state = NotificationState();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    LoggerService.loggerInstance.dynamic_d(args);

    if (args != null && args == "whatsapp") {
      changeTab(1);
    } else {
      loadEmailProviders();
    }
  }

  final tokenController = TextEditingController();

  void changeTab(int index) async {
    if (state.selectedTab.value == index) return;
    state.selectedTab.value = index;
    if (index == 0) {
      await loadEmailProviders();
    }

    if (index == 1) {
      await loadWhatsAppConfig();
    }
  }

  /*----- Email -----*/
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

  /*----- Whatsapp -----*/
  Future<void> loadWhatsAppConfig() async {
    try {
      state.isLoading.value = true;
      final res = await WhatsAppIntegrationApi.getWhatsAppConfig();
      state.whatsAppConfig.value = res;
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
          "Failed to fetch Whatsapp Configuration",
        );
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

  Future<void> saveToken() async {
    final token = tokenController.text.trim();
    if (token.isEmpty) {
      AppSnackbar.warning(
        title: "Token Required",
        message: "Kindly enter your API token.",
      );
      return;
    }
    if (token.length <= 10) {
      AppSnackbar.warning(
        title: "Invalid Token",
        message: "Token must be greater than 10 characters.",
      );
      return;
    }

    try {
      state.isSavingToken.value = true;
      await WhatsAppIntegrationApi.saveWhatsAppToken(token);
      AppSnackbar.success(
        title: "Success",
        message: "WhatsApp token saved successfully.",
      );
      tokenController.clear();
      state.isSavingToken.value = false;
      loadWhatsAppConfig();
    } catch (err) {
      state.isSavingToken.value = false;
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to save WhatsApp token");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    }
  }

  Future<void> disconnectWhatsApp() async {
    try {
      state.isSavingToken.value = true;
      await WhatsAppIntegrationApi.deleteWhatsAppConfig();

      AppSnackbar.success(
        title: "Disconnected",
        message: "WhatsApp integration disconnected successfully.",
      );
      state.isSavingToken.value = false;
      loadWhatsAppConfig();
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      state.isDeleting.value = false;
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to disconnect WhatsApp");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    }
  }

  Future<void> openMyBotify() async {
    final Uri url = Uri.parse("https://whatsapp.mybotify.com/");
    await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView, // opens inside app
    );
  }
}
