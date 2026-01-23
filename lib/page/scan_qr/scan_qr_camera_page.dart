import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/page/scan_qr/scan_qr_corner_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCameraSection extends StatelessWidget {
  final QrScanScreenController controller = Get.find();
  final Size size;

  ScanQrCameraSection({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Observe reactive state to trigger rebuild when scanner is ready
      final isScannerReady = controller.state.isScannerReady.value;

      return Stack(
        children: [
          // Scanner
          ClipRRect(
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
          ),

          // Overlay
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

          // Scan frame
          Center(
            child: SizedBox(
              width: size.width * 0.7,
              height: size.width * 0.7,
              child: Stack(
                children: const [
                  ScanQrCorner(alignment: Alignment.topLeft),
                  ScanQrCorner(alignment: Alignment.topRight),
                  ScanQrCorner(alignment: Alignment.bottomLeft),
                  ScanQrCorner(alignment: Alignment.bottomRight),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
