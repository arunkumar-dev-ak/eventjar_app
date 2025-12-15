import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyQrGlowingPulse extends StatelessWidget {
  MyQrGlowingPulse({
    super.key,
    required this.size,
    this.baseScale = 0.60,
    this.borderRadius = 28,
  });

  final Size size;
  final double baseScale;
  final double borderRadius;

  final MyQrScreenController controller = Get.find<MyQrScreenController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.pulseAnimation,
      builder: (context, child) {
        final pulse = controller.pulseAnimation.value;

        return Container(
          width: size.width * baseScale * pulse,
          height: size.width * baseScale * pulse,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientLightStart.withValues(alpha: 0.4),
                blurRadius: 40 * pulse,
                spreadRadius: 5 * pulse,
              ),
              BoxShadow(
                color: AppColors.gradientLightEnd.withValues(alpha: 0.2),
                blurRadius: 60 * pulse,
                spreadRadius: 10 * pulse,
              ),
            ],
          ),
        );
      },
    );
  }
}
