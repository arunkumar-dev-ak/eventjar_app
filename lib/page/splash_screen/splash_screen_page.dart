import 'package:eventjar_app/controller/splashScreen/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class SplashScreenPage extends GetView<SplashScreenController> {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientLightStart.withValues(alpha: 0.2),
                AppColors.gradientDarkEnd.withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: controller.logoScale.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/event_jar_logo.svg',
                          width: 15.wp,
                          height: 15.hp,
                          semanticsLabel: 'Event Jar Logo',
                        ),
                        SizedBox(height: 2.hp),
                        GradientText(
                          textSize: 11.sp,
                          content: controller.title.toUpperCase(),
                          gradientStart: AppColors.gradientDarkStart,
                          gradientEnd: AppColors.gradientDarkEnd,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
