import 'package:dio/dio.dart';
import 'package:eventjar/api/email_notification_api/email_notification_api.dart';
import 'package:eventjar/controller/email_notification/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/model/notification/email_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailNotificationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final state = EmailNotificationState();

  final smtpHost = TextEditingController();
  final smtpPort = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final fromName = TextEditingController();
  final fromEmail = TextEditingController();
  final replyToEmail = TextEditingController();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();

    final provider = Get.arguments as EmailProvider;
    state.provider.value = provider;

    // Prefill from provider
    smtpHost.text = provider.host;
    smtpPort.text = provider.port.toString();
    state.isSecure.value = provider.secure;
  }

  void togglePassword() {
    state.showPassword.value = !state.showPassword.value;
  }

  // Future<void> _checkInitialOAuthStatus() async {
  //   final provider = state.provider.value;

  //   if (provider?.oauthProvider == 'google') {
  //     await _fetchGoogleStatus(showSnackbar: false);
  //   } else if (provider?.oauthProvider == 'microsoft') {
  //     await _fetchMicrosoftStatus(showSnackbar: false);
  //   }
  // }

  Future<void> _fetchMicrosoftStatus({bool showSnackbar = false}) async {
    state.isOauthLoading.value = true;
    try {
      final res = await EmailNotificationApi.getMicrosoftStatus();

      state.isConnected.value = res.connected;

      if (showSnackbar && res.connected) {
        AppSnackbar.success(
          title: "Connected",
          message: "Microsoft account connected successfully",
        );
      }
    } catch (err) {
      _handleError(err, "Failed to check Microsoft status");
    } finally {
      state.isOauthLoading.value = false;
    }
  }

  Future<void> _fetchGoogleStatus({bool showSnackbar = false}) async {
    try {
      state.isOauthLoading.value = true;
      final res = await EmailNotificationApi.getGoogleStatus();

      state.isConnected.value = res.connected;

      if (showSnackbar && res.connected) {
        AppSnackbar.success(
          title: "Connected",
          message: "Google account connected successfully",
        );
      }
    } catch (err) {
      _handleError(err, "Failed to check Google status");
    } finally {
      state.isOauthLoading.value = false;
    }
  }

  Future<void> testEmailConfig() async {
    if (!formKey.currentState!.validate()) return;

    try {
      state.isTesting.value = true;

      final body = {
        "smtpHost": smtpHost.text.trim(),
        "smtpPort": int.tryParse(smtpPort.text.trim()),
        "smtpUsername": username.text.trim(),
        "smtpPassword": password.text.trim(),
        // "fromName": fromName.text.trim(),
        "fromEmail": fromEmail.text.trim(),
        "toEmail": replyToEmail.text.trim(),
        "smtpSecure": state.isSecure.value,
      };

      final success = await EmailNotificationApi.testEmailConfig(body);

      if (success) {
        AppSnackbar.success(
          title: "Success",
          message: "Email configuration is valid",
        );
      }
    } catch (err) {
      _handleError(err, "Email test failed");
    } finally {
      state.isTesting.value = false;
    }
  }

  Future<void> saveEmailConfig() async {
    if (!formKey.currentState!.validate()) return;

    try {
      state.isLoading.value = true;

      final body = {
        "smtpHost": smtpHost.text.trim(),
        "smtpPort": int.tryParse(smtpPort.text.trim()),
        "smtpUsername": username.text.trim(),
        "smtpPassword": password.text.trim(),
        "fromName": fromName.text.trim(),
        "fromEmail": fromEmail.text.trim(),
        "replyToEmail": replyToEmail.text.trim(),
        "smtpSecure": state.isSecure.value,
      };

      final success = await EmailNotificationApi.saveEmailConfig(body);

      if (success) {
        AppSnackbar.success(
          title: "Saved",
          message: "Email configuration saved successfully",
        );

        Navigator.pop(Get.context!, "configured");
      }
    } catch (err) {
      _handleError(err, "Saving email configuration failed");
    } finally {
      state.isLoading.value = false;
    }
  }

  void connectOAuth() {
    final provider = state.provider.value;
    if (provider?.oauthProvider == 'google') {
      connectGoogle();
    } else if (provider?.oauthProvider == 'microsoft') {
      connectMicrosoft();
    }
  }

  Future<void> connectGoogle() async {
    try {
      state.isOauthLoading.value = true;

      // final oldStatus = state.isConnected.value;

      final res = await EmailNotificationApi.connectGoogle();
      await launchUrl(
        Uri.parse(res.authUrl),
        mode: LaunchMode.inAppBrowserView,
      );
      LoggerService.loggerInstance.dynamic_d("runned after");

      await _fetchGoogleStatus(showSnackbar: false);

      // final newStatus = state.isConnected.value;

      // if (!oldStatus && newStatus) {
      //   Get.back(result: "connected");
      // }
    } catch (err) {
      _handleError(err, "Failed to connect Google");
    } finally {
      state.isOauthLoading.value = false;
    }
  }

  Future<void> connectMicrosoft() async {
    try {
      state.isOauthLoading.value = true;

      // final oldStatus = state.isConnected.value;

      final res = await EmailNotificationApi.connectMicrosoft();
      await launchUrl(
        Uri.parse(res.authUrl),
        mode: LaunchMode.inAppBrowserView,
      );

      await _fetchMicrosoftStatus(showSnackbar: false);

      // final newStatus = state.isConnected.value;

      // if (!oldStatus && newStatus) {
      //   Get.back(result: "connected");
      // }
    } catch (err) {
      _handleError(err, "Failed to connect Microsoft");
    } finally {
      state.isOauthLoading.value = false;
    }
  }

  void _handleError(dynamic err, String message) {
    if (err is DioException) {
      final statusCode = err.response?.statusCode;

      if (statusCode == 401) {
        UserStore.to.clearStore();
        navigateToSignInPage();
        return;
      }

      ApiErrorHandler.handleError(err, message);
    } else if (err is Exception) {
      AppSnackbar.error(title: "Exception", message: err.toString());
    } else {
      AppSnackbar.error(
        title: "Error",
        message: "Something went wrong (${err.runtimeType})",
      );
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        // loadEmailProviders();
      }
    });
  }
}
