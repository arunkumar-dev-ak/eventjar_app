import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/page/scan_qr/scan_qr_corner_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:showcaseview/showcaseview.dart';

class ScanQrCameraSection extends StatelessWidget {
  final QrScanScreenController controller = Get.find();
  final Size size;

  ScanQrCameraSection({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scanner (reactive — only this part rebuilds)
        Obx(() {
          final isScannerReady = controller.state.isScannerReady.value;
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            child: isScannerReady && controller.scannerController != null
                ? MobileScanner(
                    key: ValueKey(controller.scannerController.hashCode),
                    controller: controller.scannerController,
                    onDetect: controller.onDetect,
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white54),
                    ),
                  ),
          );
        }),

        // Overlay (static)
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
              ],
              stops: const [0.0, 0.2, 0.8, 1.0],
            ),
          ),
        ),

        // Scan frame with Showcase (static — not inside Obx)
        Center(
          child: Showcase(
            scope: QrScanScreenController.scanQrScope,
            key: controller.tourCameraKey,
            title: 'scan_a_qr'.tr,
            description: 'Hold the QR inside the frame.',
            tooltipBackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E293B)
                    : AppColors.gradientDarkStart,
            textColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            descTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.4,
            ),
            tooltipBorderRadius: const BorderRadius.all(Radius.circular(12)),
            targetBorderRadius: BorderRadius.circular(12),
            targetPadding: const EdgeInsets.all(4),
            child: SizedBox(
              width: size.width * 0.7,
              height: size.width * 0.7,
              child: const Stack(
                children: [
                  ScanQrCorner(alignment: Alignment.topLeft),
                  ScanQrCorner(alignment: Alignment.topRight),
                  ScanQrCorner(alignment: Alignment.bottomLeft),
                  ScanQrCorner(alignment: Alignment.bottomRight),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
