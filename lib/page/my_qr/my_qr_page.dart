import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_qr/my_qr_card.dart' show MyQrCard;
import 'package:eventjar/page/my_qr/my_qr_glowing_pulse.dart';
import 'package:eventjar/page/my_qr/my_qr_rotating_ring.dart';
import 'package:eventjar/page/my_qr/my_qr_share_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyQrCodePage extends GetView<MyQrScreenController> {
  const MyQrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            AppColors.gradientLightStart.withValues(alpha: 0.05),
            AppColors.gradientLightEnd.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated QR Code Container
            Stack(
              alignment: Alignment.center,
              children: [
                // Rotating gradient ring
                MyQrRotatingGradientBorder(size: size),
                // Pulsing glow effect
                MyQrGlowingPulse(size: size),
                // QR container
                MyQrCard(size: size),
              ],
            ),
            SizedBox(height: 5.hp),
            // Share Button
            MyQrShareButton(),
            SizedBox(height: 3.hp),
            // Hint Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Scan to save my contacts in Eventjar for flawless networking',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 9.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
