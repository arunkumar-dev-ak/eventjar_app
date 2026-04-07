import 'package:app_links/app_links.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final _appLinks = AppLinks();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // App opened from closed state
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    // App already running
    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });

    _isInitialized = true;
  }

  void _handleUri(Uri uri) {
    LoggerService.loggerInstance.dynamic_d("DeepLinkHandler: $uri");
    LoggerService.loggerInstance.dynamic_d("uriPath: ${uri.path}");

    if (uri.path == '/linkedin') {
      final code = uri.queryParameters['code'];

      LoggerService.loggerInstance.dynamic_d("code: $code");

      if (code != null) {
        // 👉 Navigate using GetX
        // Get.offAllNamed(RouteName.linkedinAuthHandlerPage, arguments: code);
        Get.toNamed(
          RouteName.authProcessingPage,
          arguments: {'provider': 'linkedin', 'code': code},
        )?.then((result) {
          if (result == "logged_in") {
            Navigator.pop(Get.context!, "logged_in");
          }
        });
      }
    }
  }
}
