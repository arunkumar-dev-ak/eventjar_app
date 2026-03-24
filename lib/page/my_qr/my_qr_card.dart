import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCard extends StatelessWidget {
  MyQrCard({super.key, required this.size});

  final Size size;

  final MyQrScreenController controller = Get.find<MyQrScreenController>();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.qrKey,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientLightStart.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.gradientLightStart.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: QrImageView(
            data: controller.qrData,
            version: QrVersions.auto,
            size: size.width * 0.45,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.gradientLightStart,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.gradientLightStart,
            ),
          ),
        ),
      ),
    );
  }
}
