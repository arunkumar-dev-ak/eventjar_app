import 'dart:math' as math;

import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyQrRotatingGradientBorder extends StatelessWidget {
  MyQrRotatingGradientBorder({super.key, required this.size});

  final Size size;

  final MyQrScreenController controller = Get.find<MyQrScreenController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.rotateController,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.rotateController.value * 2 * math.pi,
          child: Container(
            width: size.width * 0.70,
            height: size.width * 0.70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              gradient: SweepGradient(
                colors: [
                  AppColors.gradientLightStart.withValues(alpha: 0.3),
                  AppColors.gradientLightEnd.withValues(alpha: 0.1),
                  AppColors.gradientLightStart.withValues(alpha: 0.0),
                  AppColors.gradientLightEnd.withValues(alpha: 0.1),
                  AppColors.gradientLightStart.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
