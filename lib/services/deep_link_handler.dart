import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/referrer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  bool _streamRegistered = false;

  static const _lastConsumedLinkKey = 'last_consumed_deep_link';

  // Cold-start URI resolution.
  Future<Uri?> resolveInitialUri() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        final prefs = await SharedPreferences.getInstance();
        final lastConsumed = prefs.getString(_lastConsumedLinkKey);
        if (lastConsumed == initialUri.toString()) {
          return null; // Guard against stale intents
        }
        await prefs.setString(_lastConsumedLinkKey, initialUri.toString());
        return initialUri;
      }
    } catch (e) {
      LoggerService.loggerInstance.e("getInitialLink error: $e");
    }

    if (Platform.isAndroid) {
      try {
        final token = await ReferrerService.getInviteTokenIfAny();
        if (token != null) {
          return Uri.parse("https://myeventjar.com/invite/$token");
        }
      } catch (e) {
        LoggerService.loggerInstance.e("ReferrerService error: $e");
      }
    }

    return null;
  }

  // Register the warm-state stream listener.
  void listenForLinks() {
    if (_streamRegistered) return;
    _streamRegistered = true;

    _sub = _appLinks.uriLinkStream.listen(
      (uri) => handleUri(uri),
      onError: (Object e) {
        LoggerService.loggerInstance.e("uriLinkStream error: $e");
      },
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _streamRegistered = false;
  }

  // Cold-start dispatch.
  Future<void> handleColdStartUri(Uri uri) async {
    final consumed = await _dispatch(uri, isCold: true);
    if (!consumed) {
      Get.offAllNamed(RouteName.dashboardpage);
    }
  }

  // Warm-state dispatch (foreground / background → resume).
  Future<void> handleUri(Uri uri) async {
    await _dispatch(uri, isCold: false);
  }

  Future<bool> _dispatch(Uri uri, {required bool isCold}) async {
    // Custom scheme: myeventjar://widget?action=...
    if (uri.scheme == 'myeventjar' && uri.host == 'widget') {
      await _handleWidgetAction(uri.queryParameters['action'], isCold: isCold);
      return true;
    }

    final segments = uri.pathSegments;
    if (segments.isEmpty || segments.first.isEmpty) return false;

    switch (segments.first) {
      case 'invite':
      case 'staff-invite':
        final token = segments.length > 1 ? segments[1].trim() : null;

        if (token == null || token.isEmpty) {
          AppSnackbar.warning(
            title: "invalid_invite".tr,
            message: "Please try another link.",
          );
          return false;
        }

        Get.offAllNamed(
          RouteName.dashboardpage,
          arguments: {
            "initialTab": 0,
            "openSubPage": "signUpPage",
            "token": token,
          },
        );
        return true;

      case 'events':
        final slug = segments.length > 1 ? segments[1].trim() : null;

        if (slug == null || slug.isEmpty) {
          AppSnackbar.warning(
            title: "Invalid Event",
            message: "Event link is not valid.",
          );
          return false;
        }

        Get.offAllNamed(
          RouteName.dashboardpage,
          arguments: {
            "initialTab": 0,
            "openSubPage": "eventInfo",
            "isLoginRequired": true,
            "parameters": {"eventId": slug},
          },
        );
        return true;

      case 'trips':
        if (segments.length > 2 && segments[1] == 'join') {
          // TODO: route to actual trip-join page once available.
          Get.offAllNamed(RouteName.dashboardpage);
          return true;
        }
        return false;

      case 'my-tickets':
        Get.offAllNamed(
          RouteName.dashboardpage,
          arguments: {"initialTab": 3, "isLoginRequired": true},
        );
        return true;

      case 'network':
        Get.offAllNamed(
          RouteName.dashboardpage,
          arguments: {
            "initialTab": 1,
            "openSubPage": "contact",
            "isLoginRequired": true,
          },
        );
        return true;

      case 'connections':
        Get.offAllNamed(
          RouteName.dashboardpage,
          arguments: {
            "initialTab": 1,
            "openSubPage": "connection",
            "connectionTab": 1,
            "isLoginRequired": true,
          },
        );
        return true;

      case 'members':
        final memberUsername = segments.length > 1 ? segments[1].trim() : null;
        if (memberUsername == null || memberUsername.isEmpty) {
          AppSnackbar.warning(
            title: "Invalid Profile",
            message: "Profile link is not valid.",
          );
          return false;
        }
        Get.offAllNamed('${RouteName.bioProfilePage}?username=$memberUsername');
        return true;

      case 'find-events':
        Get.offAllNamed(RouteName.dashboardpage);
        return true;

      case 'linkedin':
        final authSessionId = uri.queryParameters['auth_session_id'];
        if (authSessionId == null) return false;

        Get.toNamed(
          RouteName.authProcessingPage,
          arguments: {'provider': 'linkedin', 'authSessionId': authSessionId},
        )?.then((result) {
          if (result == "logged_in" && Get.context != null) {
            Navigator.pop(Get.context!, "logged_in");
          }
        });
        return true;
    }

    return false;
  }

  Future<void> _handleWidgetAction(
    String? action, {
    required bool isCold,
  }) async {
    if (action == null) return;

    String? target;
    switch (action) {
      case 'scan_qr':
        target = RouteName.qrDashboardPage;
        break;
      case 'add_contact':
        target = RouteName.addContactPage;
        break;
      case 'nfc_tap':
        target = RouteName.nfcReadPage;
        break;
      case 'scan_card':
        target = RouteName.scanCardPage;
        break;
    }
    if (target == null) return;

    Get.offAllNamed(
      RouteName.dashboardpage,
      arguments: {
        "openSubPage": "widgetAction",
        "widgetRoute": target,
        "isLoginRequired": true,
      },
    );
  }
}
