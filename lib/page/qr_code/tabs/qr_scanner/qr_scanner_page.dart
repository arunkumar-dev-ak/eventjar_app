import 'package:eventjar/controller/qr_code/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerView extends StatelessWidget {
  final QrCodeScreenController controller = Get.find();
  QrScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: controller.cameraController,
            onDetect: (BarcodeCapture capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              final value = barcodes.first.rawValue;
              if (value != null) {
                debugPrint('Scanned: $value');
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.cameraswitch),
              onPressed: controller.toggleCamera,
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: controller.scanFromGallery,
            ),
          ],
        ),
      ],
    );
  }
}
