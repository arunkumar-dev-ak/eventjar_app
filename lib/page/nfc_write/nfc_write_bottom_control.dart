import 'dart:io';

import 'package:eventjar/controller/nfc_write/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcWriteBottomControls extends StatelessWidget {
  const NfcWriteBottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NfcWriteController>();

    return Obx(() {
      final hasError = controller.state.errorMessage.value != null;

      if (hasError) {
        final isIos = Platform.isIOS;
        return Container(
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: isIos ? Get.back : controller.resetAndScan,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isIos ? Colors.blueGrey : Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isIos ? 'Go Back' : 'Try Again',
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
