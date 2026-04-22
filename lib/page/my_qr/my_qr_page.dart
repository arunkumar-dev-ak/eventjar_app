import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_qr/my_qr_card.dart' show MyQrCard;
import 'package:eventjar/page/my_qr/my_qr_glowing_pulse.dart';
import 'package:eventjar/page/my_qr/my_qr_rotating_ring.dart';
import 'package:eventjar/page/my_qr/my_qr_share_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

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
            Showcase(
              key: controller.tourQrKey,
              title: 'Your QR Code',
              description:
                  'Show this to someone so they can scan and instantly save your contact in Eventjar.',
              tooltipBackgroundColor: AppColors.gradientLightStart,
              textColor: Colors.white,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              descTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MyQrRotatingGradientBorder(size: size),
                  MyQrGlowingPulse(size: size),
                  MyQrCard(size: size),
                ],
              ),
            ),
            SizedBox(height: 5.hp),
            Showcase(
              key: controller.tourShareKey,
              title: 'Share your QR',
              description:
                  'Tap to send the QR as an image via any app — WhatsApp, email, AirDrop, and more.',
              tooltipBackgroundColor: AppColors.gradientLightEnd,
              textColor: Colors.white,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              descTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              child: MyQrShareButton(),
            ),
            SizedBox(height: 3.hp),
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
