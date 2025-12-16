import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/page/scan_qr/scan_qr_bottom_section.dart';
import 'package:eventjar/page/scan_qr/scan_qr_camera_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanQrPage extends GetView<QrScanScreenController> {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(child: ScanQrCameraSection(size: size)),
        ScanQrBottomSection(colorScheme: colorScheme),
      ],
    );
  }
}
