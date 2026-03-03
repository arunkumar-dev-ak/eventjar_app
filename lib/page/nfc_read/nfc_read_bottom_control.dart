import 'package:eventjar/controller/nfc_read/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcReadBottomControls extends StatelessWidget {
  const NfcReadBottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NfcReadController>();

    return Obx(() {
      final hasError = controller.state.errorMessage.value != null;
      final scanComplete = controller.state.scanComplete.value;

      if (hasError) {
        return Container(
          padding: EdgeInsets.all(5.wp),
          child: ElevatedButton(
            onPressed: controller.resetAndScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.hp, horizontal: 5.wp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Try Again',
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      if (scanComplete) {
        return Container(
          padding: EdgeInsets.all(5.wp),
          child: ElevatedButton(
            onPressed: controller.resetAndScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.hp, horizontal: 5.wp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Scan Another Card',
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
