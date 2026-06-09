import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ScanQrBottomSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final QrScanScreenController controller = Get.find();

  ScanQrBottomSection({required this.colorScheme, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Info / enable card
          Obx(() {
            final hasCamera = controller.state.isCameraAccessGranted.value;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientLightStart.withValues(alpha: 0.1),
                    AppColors.gradientLightEnd.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.gradientLightStart.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientLightStart,
                          AppColors.gradientLightEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'point_camera_at_qr'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.hp),
                        Text(
                          hasCamera
                              ? 'camera_ready_frame_desc'.tr
                              : 'enable_camera_scan_desc'.tr,
                          style: TextStyle(
                            fontSize: 7.5.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Only show button when camera is NOT enabled
                  if (!hasCamera) const SizedBox(width: 12),
                  if (!hasCamera)
                    ElevatedButton(
                      onPressed: () => controller.requestCameraPermission(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gradientLightStart,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'enable_camera'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),

          SizedBox(height: 1.5.hp),

          // Scan from Gallery button (same as before)
          Showcase(
            scope: QrScanScreenController.scanQrScope,
            key: controller.tourGalleryKey,
            title: 'from_gallery'.tr,
            description: 'pick_image_with_qr'.tr,
            tooltipBackgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : AppColors.gradientDarkStart,
            textColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            descTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.4,
            ),
            tooltipBorderRadius: const BorderRadius.all(Radius.circular(12)),
            targetBorderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientLightStart,
                    AppColors.gradientLightEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientLightStart.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => controller.scanFromGallery(),
                icon: const Icon(Icons.photo_library_rounded),
                label: Flexible(
                  child: Text(
                    'scan_from_gallery'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
