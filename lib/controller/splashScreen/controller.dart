import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/controller/splashScreen/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/deep_link_handler.dart';
import 'package:eventjar/services/nfc_intent_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController
    with GetTickerProviderStateMixin {
  var title = "Experience Events, Build Connections";
  var state = SplashScreenState();

  // Animation controllers
  late AnimationController mainAnimationController;
  late AnimationController iconAnimationController;

  // Text animations
  late Animation<double> connectOpacity;
  late Animation<Offset> connectSlide;

  late Animation<double> collaborateOpacity;
  late Animation<Offset> collaborateSlide;

  late Animation<double> growOpacity;
  late Animation<Offset> growSlide;

  late Animation<double> taglineOpacity;
  late Animation<Offset> taglineSlide;

  // Icons animations
  late Animation<double> iconsOpacity;
  late Animation<double> iconsScale;

  // Logo animation
  late Animation<double> logoOpacity;
  late Animation<double> logoScale;

  // Network animation
  late Animation<double> networkOpacity;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _startAnimations();
    _navigateToHome();
  }

  void _setupAnimations() {
    // Main animation controller for text (2.5 seconds total)
    mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Icon animation controller
    iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // "Connect." animation (0% - 25%)
    connectOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );
    connectSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: mainAnimationController,
            curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
          ),
        );

    // "Collaborate." animation (15% - 40%)
    collaborateOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.15, 0.40, curve: Curves.easeOut),
      ),
    );
    collaborateSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: mainAnimationController,
            curve: const Interval(0.15, 0.40, curve: Curves.easeOut),
          ),
        );

    // "Grow." animation (30% - 55%)
    growOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
      ),
    );
    growSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: mainAnimationController,
            curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
          ),
        );

    // Tagline animation (50% - 75%)
    taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.50, 0.75, curve: Curves.easeOut),
      ),
    );
    taglineSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: mainAnimationController,
            curve: const Interval(0.50, 0.75, curve: Curves.easeOut),
          ),
        );

    // Icons animation (65% - 85%)
    iconsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );
    iconsScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.65, 0.85, curve: Curves.elasticOut),
      ),
    );

    // Logo animation (80% - 100%)
    logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOut),
      ),
    );
    logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Network animation (starts early and fades in)
    networkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
  }

  void _startAnimations() {
    mainAnimationController.forward();
  }

  /*----- Navigation And IOS deeplink handler -----*/
  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    // 1. Cold-start deep link (Universal Links / App Links, plus the
    //    Android Play Install Referrer fallback). If we have one, it
    //    decides where to land — no other navigation should override it.
    final initialUri = await DeepLinkHandler().resolveInitialUri();
    if (initialUri != null) {
      await DeepLinkHandler().handleColdStartUri(initialUri);
    } else {
      // 2. Otherwise: iOS deferred install token, else dashboard.
      await _resolveInstallFlow();
    }

    // 3. Listen for warm-state links (app already running / in background).
    DeepLinkHandler().listenForLinks();

    // Notify NFC after navigation settles
    Future.delayed(const Duration(milliseconds: 500), () {
      NfcIntentHandler().onAppReady();
    });
  }

  Future<void> _resolveInstallFlow() async {
    if (Platform.isIOS) {
      final token = await getInviteTokenIfAny();

      if (token != null) {
        Get.offAllNamed(RouteName.signUpPage, arguments: {'token': token});
        return;
      }
    }

    // Default fallback. Use offAllNamed so splash leaves the back stack.
    Get.offAllNamed(RouteName.dashboardpage);
  }

  Future<String?> getInviteTokenIfAny() async {
    const key = "ios_deeplink_checked";
    if (!Platform.isIOS) return null;

    final prefs = await SharedPreferences.getInstance();
    final alreadyChecked = prefs.getBool(key) ?? false;

    if (alreadyChecked) return null;

    try {
      state.isResolvingDeepLink.value = true;

      final deviceData = await _collectDeviceData();

      final response = await DioClient().dio.post(
        '/mobile/deep-links/match-install',
        data: deviceData,
      );

      if (response.data['matched'] == true) {
        final path = response.data['link_path'];

        if (path != null) {
          final uri = Uri.parse("https://myeventjar.com$path");

          if (uri.pathSegments.length > 1 &&
              uri.pathSegments.first == 'invite') {
            return uri.pathSegments[1];
          }
        }
      }
    } catch (e) {
      LoggerService.loggerInstance.e("iOS deep link match error: $e");
    } finally {
      state.isResolvingDeepLink.value = false;
      await prefs.setBool(key, true);
    }

    return null;
  }

  Future<Map<String, dynamic>> _collectDeviceData() async {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    final view = WidgetsBinding.instance.platformDispatcher.views.first;

    return {
      "screen_width": view.physicalSize.width.toInt(),
      "screen_height": view.physicalSize.height.toInt(),
      "timezone_offset": DateTime.now().timeZoneOffset.inMinutes,
      "locale": Platform.localeName.split('.').first,
      "os_version": iosInfo.systemVersion,
      "device_model": iosInfo.utsname.machine,
    };
  }

  @override
  void onClose() {
    mainAnimationController.dispose();
    iconAnimationController.dispose();
    super.onClose();
  }
}
