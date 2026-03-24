import 'package:eventjar/controller/nfc_write/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcWriteScanningZone extends GetView<NfcWriteController> {
  const NfcWriteScanningZone({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NfcWriteController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.wp),
      child: Obx(() {
        // Error state
        if (controller.state.errorMessage.value != null) {
          return SingleChildScrollView(child: _ErrorPreview());
        }

        return Container(
          width: 100.wp,
          padding: EdgeInsets.all(5.wp),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.green.withValues(alpha: 0.1), Colors.transparent],
              center: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing NFC animation
              SizedBox(
                height: 200,
                child: AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer pulse
                        Opacity(
                          opacity: (1 - controller.animationController.value),
                          child: Transform.scale(
                            scale:
                                1.5 +
                                controller.animationController.value * 0.8,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                        ),
                        // NFC icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.green.shade600],
                            ),
                          ),
                          child: Icon(Icons.nfc, color: Colors.white, size: 40),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 24),

              Text(
                'Tap NFC Behind Camera',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Hold your NFC card against the back of your phone',
                style: TextStyle(fontSize: 8.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ErrorPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NfcWriteController>();

    return Padding(
      padding: EdgeInsets.all(4.wp),
      child: Container(
        width: 100.wp,
        padding: EdgeInsets.all(5.wp),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.red.shade400),
            SizedBox(height: 3.wp),
            Text(
              'Scan Failed',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 1.5.wp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.wp),
              child: Text(
                controller.state.errorMessage.value ?? 'Unknown error',
                style: TextStyle(fontSize: 9.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
