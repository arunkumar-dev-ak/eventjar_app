import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/referrer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final _appLinks = AppLinks();

  StreamSubscription<Uri>? _sub;
  bool _streamRegistered = false;

  /// Cold-start URI resolution. Checks the OS-delivered launch URI first
  /// (Universal Links / App Links), then falls back to the Play Install
  /// Referrer on Android. Returns null if there is no cold-start link.
  Future<Uri?> resolveInitialUri() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        LoggerService.loggerInstance.dynamic_d(
          "DeepLinkHandler initial: $initialUri",
        );
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

  /// Register the warm-state stream listener. Call this once after splash
  /// has finished navigating, so links that arrive while the app is in the
  /// foreground or background are routed correctly.
  void listenForLinks() {
    if (_streamRegistered) return;
    _streamRegistered = true;

    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        handleUri(uri);
      },
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

  /// Cold-start dispatch. Splash calls this with the URI returned by
  /// [resolveInitialUri]. If the URI doesn't match any known route we
  /// still need to leave splash, so we fall back to the dashboard.
  Future<void> handleColdStartUri(Uri uri) async {
    final consumed = await _dispatch(uri, isCold: true);
    if (!consumed) {
      Get.offAllNamed(RouteName.dashboardpage);
    }
  }

  /// Warm-state dispatch (foreground / background → resume).
  Future<void> handleUri(Uri uri) async {
    await _dispatch(uri, isCold: false);
  }

  Future<bool> _dispatch(Uri uri, {required bool isCold}) async {
    LoggerService.loggerInstance.dynamic_d(
      "DeepLinkHandler dispatch (cold=$isCold): $uri",
    );

    // Custom scheme: myeventjar://widget?action=...
    if (uri.scheme == 'myeventjar' && uri.host == 'widget') {
      await _handleWidgetAction(uri.queryParameters['action'], isCold: isCold);
      return true;
    }

    final segments = uri.pathSegments;
    if (segments.isEmpty || segments.first.isEmpty) return false;

    switch (segments.first) {
      case 'invite':
        if (segments.length > 1) {
          final token = segments[1];
          Get.offAllNamed(RouteName.signUpPage, arguments: {'token': token});
          return true;
        }
        return false;

      case 'events':
        if (segments.length > 1) {
          final slug = segments[1];
          await _openOnDashboard(
            isCold: isCold,
            route: RouteName.eventInfoPage,
            // arguments: {'eventId': slug},
            parameters: {'eventId': slug},
          );
          return true;
        }
        return false;

      case 'staff-invite':
        if (segments.length > 1) {
          final token = segments[1];
          await _openOnDashboard(
            isCold: isCold,
            route: RouteName.staffInvitePage,
            arguments: {'token': token},
          );
          return true;
        }
        return false;

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

      case 'find-events':
        Get.offAllNamed(RouteName.dashboardpage);
        return true;

      case 'linkedin':
        final authSessionId = uri.queryParameters['auth_session_id'];
        if (authSessionId == null) return false;

        // OAuth callback: the user initiated LinkedIn sign-in from the
        // sign-in page, so we always push on top of whatever is current.
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

  /// Sub-page deep links (events, staff-invite, etc.).
  ///
  /// On cold start we navigate directly to the target page with
  /// [Get.offAllNamed]. Trying to layer the dashboard underneath ran into
  /// a timing race: the dashboard's bindings hadn't finished by the time
  /// we pushed the sub-page on top, which surfaced as a black screen.
  /// Direct navigation removes that race entirely.
  ///
  /// Warm start (app already past splash) keeps the original behaviour:
  /// just push on top of the current stack.
  Future<void> _openOnDashboard({
    required bool isCold,
    required String route,
    Map<String, dynamic>? arguments,
    Map<String, String>? parameters,
  }) async {
    if (isCold || Get.currentRoute == RouteName.splashScreen) {
      Get.offAllNamed(route, arguments: arguments, parameters: parameters);
      return;
    }
    Get.toNamed(route, arguments: arguments);
  }

  Future<void> _handleWidgetAction(
    String? action, {
    required bool isCold,
  }) async {
    LoggerService.loggerInstance.dynamic_d("Widget action: $action");
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

    await _openOnDashboard(isCold: isCold, route: target);
  }
}
