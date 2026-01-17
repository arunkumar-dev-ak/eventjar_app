import 'package:eventjar/controller/nfc/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/nfc/widget/nfc_page_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcAnimatedHeader extends GetView<NfcController> {
  const NfcAnimatedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // NFC rings + icon
        SizedBox(
          height: 150,
          child: AnimatedBuilder(
            animation: controller.pulseAnimation1,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulse ring
                  PulseRing(
                    animation: controller.pulseAnimation2,
                    size: 120,
                    opacityFactor: 0.7,
                    color: Colors.blueAccent,
                  ),
                  // Inner pulse ring
                  PulseRing(
                    animation: controller.pulseAnimation1,
                    size: 95,
                    opacityFactor: 0.7,
                    color: Colors.cyan,
                  ),
                  // NFC icon
                  _NfcIconWithGlow(),

                  // NFC waves effect
                  _WavesRing(),
                ],
              );
            },
          ),
        ),

        SizedBox(height: 2.hp),

        // Status badge
        _StatusBadge(),

        // Profile info or setup prompt
        NfcProfilePageHeader(),
      ],
    );
  }
}

class _StatusBadge extends GetView<NfcController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final nfcStatusText = controller.getNfcStatusText();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blueAccent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              size: 7.sp,
              color: _getStatusColor(nfcStatusText),
            ),
            SizedBox(width: 1.wp),
            Text(
              nfcStatusText,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(nfcStatusText),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'NFC Ready':
        return Colors.green;
      case 'NFC Not Available':
      case 'NFC Disabled':
        return Colors.orange;
      default:
        return Colors.blueAccent;
    }
  }
}

class _NfcIconWithGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.blueAccent.withValues(alpha: 0.9),
            Colors.indigo.withValues(alpha: 0.7),
            Colors.purple.withValues(alpha: 0.4),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Icon(Icons.nfc, color: Colors.white, size: 45),
    );
  }
}

class _WavesRing extends StatelessWidget {
  final NfcController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Transform.scale(
        scale: 0.8 + 0.2 * controller.pulseAnimation1.value,
        child: Icon(
          Icons.wifi_find,
          color: Colors.cyan.withValues(alpha: 0.6),
          size: 24,
        ),
      ),
    );
  }
}

class PulseRing extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final double opacityFactor;
  final Color color;

  const PulseRing({
    required this.animation,
    required this.size,
    required this.opacityFactor,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: (1 - animation.value) * opacityFactor,
          child: Transform.scale(
            scale: (1 * animation.value + 0.4).clamp(0.4, 1.4),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.4),
                  width: 2,
                ),
                color: color.withValues(alpha: opacityFactor * 0.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: opacityFactor),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
