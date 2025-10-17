import 'package:eventjar_app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var title = "Experience Events, Build Connections";
  late AnimationController animationController;
  late Animation<double> logoScale;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );
    animationController.forward();

    _navigateToHome();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Get.offNamed(RouteName.dashboardpage);
    });
  }
}
