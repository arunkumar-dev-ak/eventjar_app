import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:eventjar/api/google_calendar_api/google_calendar_api.dart';
import 'package:eventjar/controller/google_calendar/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleCalendarController extends GetxController
    with WidgetsBindingObserver {
  final state = GoogleCalendarState();
  late Timer _textTimer;
  int _textIndex = 0;

  bool _isAwaitingBrowserReturn = false;

  final List<String> _loadingMessages = [
    "Checking calendar connection...",
    "Preparing Google integration...",
    "Syncing account details...",
    "Almost done...",
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _startLoadingTextAnimation();

    // Start the automatic flow
    _initializeAutomaticFlow();
  }

  void _startLoadingTextAnimation() {
    _textTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _textIndex = (_textIndex + 1) % _loadingMessages.length;
      state.loadingText.value = _loadingMessages[_textIndex];
    });
  }

  Future<void> _initializeAutomaticFlow() async {
    // 1. Check current status
    await fetchConnectionStatus();

    // 2. If NOT connected, automatically launch the connection flow
    if (state.connection.value?.connected == false) {
      await connectGoogleCalendar();
    }
  }

  Future<void> fetchConnectionStatus() async {
    try {
      state.isLoading.value = true;
      final response = await GoogleCalendarApi.getConnectionStatus();
      state.connection.value = response;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "error".tr,
        onUnauthorized: () {
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> connectGoogleCalendar() async {
    try {
      state.isLoading.value = true;
      final response = await GoogleCalendarApi.getConnectUrl();
      final authUrl = response.authUrl;

      if (authUrl.isEmpty) {
        AppSnackbar.error(
          title: "error".tr,
          message: "failed_initiate_google_calendar".tr,
        );
        Navigator.pop(Get.context!); // Exit page if backend fails to give URL
        return;
      }

      _isAwaitingBrowserReturn = true;

      await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      _isAwaitingBrowserReturn = false;
      AppSnackbar.error(
        title: "error".tr,
        message: "failed_connect_google_calendar".tr,
      );
      Navigator.pop(Get.context!); // Exit page on error
    }
  }

  // --- Deep Link Callback ---
  void handleDeepLinkCallback(Uri uri) async {
    _isAwaitingBrowserReturn = false;

    final status = uri.queryParameters['status'];
    final message = uri.queryParameters['message'];

    if (status == 'success') {
      AppSnackbar.success(
        title: "Success",
        message: "Google Calendar connected successfully!",
      );
      await fetchConnectionStatus();
    } else {
      AppSnackbar.error(
        title: "Connection Failed",
        message: message ?? "Failed to connect Google Calendar.",
      );
      Navigator.pop(Get.context!);
    }
  }

  // --- Fallback if deep link fails (User pressed back button in browser) ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed && _isAwaitingBrowserReturn) {
      _isAwaitingBrowserReturn = false;

      fetchConnectionStatus().then((_) {
        if (state.connection.value?.connected == false) {
          Navigator.pop(Get.context!);
        }
      });
    }
  }

  Future<void> disconnectGoogleCalendar() async {
    try {
      state.isDisconnecting.value = true;
      await GoogleCalendarApi.disconnect();

      AppSnackbar.success(
        title: "disconnected".tr,
        message: "google_calendar_disconnected".tr,
      );

      // Once disconnected, boot them back to the previous screen
      Navigator.pop(Get.context!);
    } catch (e) {
      ApiErrorHandler.handle(
        error: e,
        title: "error".tr,
        onUnauthorized: () {
          navigateToSignInPage();
        },
      );
    } finally {
      state.isDisconnecting.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        _initializeAutomaticFlow();
      } else {
        Get.back();
      }
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _textTimer.cancel();
    super.onClose();
  }
}
