import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetTickerProviderStateMixin {
  var title = "Experience Events, Build Connections";

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
    _startTime = DateTime.now();
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

  @override
  void onClose() {
    mainAnimationController.dispose();
    iconAnimationController.dispose();
    super.onClose();
  }

  void _navigateToHome() async {
    // Run initialization in parallel with splash animation
    await Global.onInit();

    // Ensure minimum splash display time of 2 seconds for animation
    final elapsed = DateTime.now().difference(_startTime).inMilliseconds;
    final remaining = 2000 - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }

    Get.offNamed(RouteName.dashboardpage);
  }

  late DateTime _startTime;
}
