import 'dart:async';
import 'package:eventjar/api/google_calendar_api/google_calendar_api.dart';
import 'package:eventjar/controller/google_calendar/state.dart';
import 'package:eventjar/global/app_snackbar.dart';

import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class GoogleCalendarController extends GetxController {
  final state = GoogleCalendarState();

  late Timer _textTimer;

  int _textIndex = 0;

  final List<String> _loadingMessages = [
    "Checking calendar connection...",
    "Preparing Google integration...",
    "Syncing account details...",
    "Almost done...",
  ];

  @override
  void onInit() {
    super.onInit();

    _startLoadingTextAnimation();

    // fetchConnectionStatus();
  }

  void _startLoadingTextAnimation() {
    _textTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _textIndex = (_textIndex + 1) % _loadingMessages.length;

      state.loadingText.value = _loadingMessages[_textIndex];
    });
  }

  Future<void> fetchConnectionStatus() async {
    try {
      state.isLoading.value = true;

      final response = await GoogleCalendarApi.getConnectionStatus();

      state.connection.value = response;
    } catch (e) {
      AppSnackbar.error(
        title: "Error",
        message: "Failed to fetch Google Calendar status",
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
          title: "Error",
          message: "Failed to initiate Google Calendar connection",
        );

        return;
      }

      await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      AppSnackbar.error(
        title: "Error",
        message: "Failed to connect Google Calendar",
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> disconnectGoogleCalendar() async {
    try {
      state.isLoading.value = true;

      await GoogleCalendarApi.disconnect();

      AppSnackbar.success(
        title: "Disconnected",
        message: "Google Calendar disconnected successfully",
      );

      await fetchConnectionStatus();
    } catch (e) {
      AppSnackbar.error(
        title: "Error",
        message: "Failed to disconnect Google Calendar",
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _textTimer.cancel();

    super.onClose();
  }
}
