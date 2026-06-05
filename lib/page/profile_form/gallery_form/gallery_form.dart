import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventjar/controller/profile_form/gallery/controller.dart';
import 'package:eventjar/controller/profile_form/gallery/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GalleryFormPage extends GetView<GalleryFormController> {
  const GalleryFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'manage_gallery'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        final existing = controller.state.existingImages;
        final newImages = controller.state.selectedImages;
        final totalCount = controller.totalCount;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.wp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, totalCount),
                    SizedBox(height: 2.hp),
                    if (existing.isNotEmpty) ...[
                      _buildSectionLabel(context, 'current_images'.tr),
                      SizedBox(height: 1.hp),
                      _buildExistingImagesGrid(context, existing),
                      SizedBox(height: 1.hp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 14,
                            color: AppColors.textHint(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'tap_image_full_screen'.tr,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.textHint(context),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.hp),
                    ],
                    if (newImages.isNotEmpty) ...[
                      _buildSectionLabel(context, "New Images"),
                      SizedBox(height: 1.hp),
                      _buildNewImagesGrid(context, newImages),
                      SizedBox(height: 2.hp),
                    ],
                    _buildAddButton(context),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, int totalCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.lightBlueBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlueBorder(context)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.photo_library_outlined,
            color: Colors.blue.shade700,
            size: 22,
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$totalCount / ${GalleryFormState.maxImages} images",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Max 5MB per image. Supports JPG, PNG",
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(context),
      ),
    );
  }

  Widget _buildExistingImagesGrid(BuildContext context, List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.wp,
        mainAxisSpacing: 2.wp,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildImageTile(
          context,
          child: GestureDetector(
            onTap: () => Get.toNamed(
              RouteName.imageViewerPage,
              arguments: {
                "fileUrl": getFileUrl(images[index]),
                "header": 'gallery'.tr,
              },
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: getFileUrl(images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, _) => Container(
                  color: AppColors.chipBg(context),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppColors.chipBg(context),
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 30,
                    color: AppColors.iconMuted(context),
                  ),
                ),
              ),
            ),
          ),
          onRemove: () => controller.removeExistingImage(index),
        );
      },
    );
  }

  Widget _buildNewImagesGrid(BuildContext context, List<File> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.wp,
        mainAxisSpacing: 2.wp,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildImageTile(
          context,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          onRemove: () => controller.removeNewImage(index),
        );
      },
    );
  }

  Widget _buildImageTile(
    BuildContext context, {
    required Widget child,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Obx(() {
      final canAdd = controller.remaining > 0;
      return GestureDetector(
        onTap: canAdd ? () => controller.showPickerOptions() : null,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 3.hp),
          decoration: BoxDecoration(
            color: canAdd
                ? AppColors.gradientDarkStart.withValues(alpha: 0.06)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: canAdd
                  ? AppColors.gradientDarkStart.withValues(alpha: 0.3)
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: canAdd
                    ? AppColors.gradientDarkStart
                    : Colors.grey.shade400,
              ),
              SizedBox(height: 1.hp),
              Text(
                canAdd
                    ? "Tap to add images (${controller.remaining} remaining)"
                    : "Maximum images reached",
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: canAdd
                      ? AppColors.gradientDarkStart
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomBar(BuildContext context) {
    return Obx(() {
      final isSaving = controller.state.isSaving.value;
      final hasChanges = controller.hasChanges;
      return Container(
        padding: EdgeInsets.fromLTRB(
          5.wp,
          1.5.hp,
          5.wp,
          1.5.hp + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow(context),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isSaving || !hasChanges ? null : controller.saveGallery,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gradientDarkStart,
              foregroundColor: Colors.white,
              disabledBackgroundColor: isSaving
                  ? AppColors.gradientDarkStart
                  : AppColors.divider(context),
              disabledForegroundColor: isSaving
                  ? Colors.white
                  : AppColors.textSecondary(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: isSaving
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'uploading'.tr,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'save_gallery'.tr,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
