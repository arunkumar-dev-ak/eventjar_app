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
    UserStore.cancelAllRequests();
    super.onInit();
    final args = Get.arguments;

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
      ApiErrorHandler.handle(
        error: err,
        title: "failed_fetch_email_config".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> disconnectEmail() async {
    try {
      state.isDeleting.value = true;
      await NotificationApi.deleteEmailConfig();
      AppSnackbar.success(
        title: "disconnection_success".tr,
        message: "email_config_disconnected".tr,
      );
      loadEmailProviders();
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      ApiErrorHandler.handle(
        error: err,
        title: "failed_disconnect_email".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
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
      ApiErrorHandler.handle(
        error: err,
        title: "failed_fetch_whatsapp_config".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> saveToken() async {
    final token = tokenController.text.trim();
    if (token.isEmpty) {
      AppSnackbar.warning(
        title: "token_required".tr,
        message: "enter_api_token_prompt".tr,
      );
      return;
    }
    if (token.length <= 10) {
      AppSnackbar.warning(
        title: "invalid_token".tr,
        message: "token_length_error".tr,
      );
      return;
    }

    try {
      state.isSavingToken.value = true;
      await WhatsAppIntegrationApi.saveWhatsAppToken(token);
      AppSnackbar.success(
        title: "success".tr,
        message: "whatsapp_token_saved".tr,
      );
      tokenController.clear();
      state.isSavingToken.value = false;
      loadWhatsAppConfig();
    } catch (err) {
      state.isSavingToken.value = false;
      LoggerService.loggerInstance.e(err);
      ApiErrorHandler.handle(
        error: err,
        title: "failed_save_whatsapp_token".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    }
  }

  Future<void> disconnectWhatsApp() async {
    try {
      state.isSavingToken.value = true;
      await WhatsAppIntegrationApi.deleteWhatsAppConfig();

      AppSnackbar.success(
        title: "disconnected".tr,
        message: "whatsapp_disconnected_success".tr,
      );
      state.isSavingToken.value = false;
      loadWhatsAppConfig();
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      state.isDeleting.value = false;
      ApiErrorHandler.handle(
        error: err,
        title: "failed_disconnect_whatsapp".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
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
