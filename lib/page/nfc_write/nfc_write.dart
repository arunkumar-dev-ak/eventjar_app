import 'package:eventjar/controller/nfc_write/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/nfc_write/nfc_write_bottom_control.dart';
import 'package:eventjar/page/nfc_write/nfc_write_header.dart';
import 'package:eventjar/page/nfc_write/nfc_write_scanning_zone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcWritePage extends GetView<NfcWriteController> {
  const NfcWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.nfc, size: 22, color: Colors.green.shade700),
            SizedBox(width: 8),
            Text(
              'Write Card',
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

      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          WriteHeader(),

          // Main scanning area (80% screen)
          Expanded(child: NfcWriteScanningZone()),

          // Bottom controls
          NfcWriteBottomControls(),
        ],
      ),
    );
  }
}
