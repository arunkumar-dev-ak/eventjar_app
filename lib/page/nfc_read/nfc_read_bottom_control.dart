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

      return Container(
        padding: EdgeInsets.all(5.wp),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: controller.cancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Cancel'),
              ),
            ),
            SizedBox(width: 4.wp),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.startScanning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: controller.state.isScanning.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        'Scan',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
