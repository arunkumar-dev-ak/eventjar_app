import 'package:eventjar/controller/nfc_read/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/nfc_read/nfc_read_bottom_control.dart';
import 'package:eventjar/page/nfc_read/nfc_read_scanning_zone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcReadPage extends GetView<NfcReadController> {
  const NfcReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.nfc,
              size: 22,
              color: Colors.blue.shade700,
            ), // Blue for Read
            SizedBox(width: 8),
            Text(
              'Read Card', // Read Card title
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
          onPressed: () => Get.back(),
        ),
        elevation: 4,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withValues(alpha: 0.9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // Main scanning area (80% screen)
          Expanded(child: NfcReadScanningZone()),

          // Bottom controls
          NfcReadBottomControls(),
        ],
      ),
    );
  }
}
