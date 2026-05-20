import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/profile_form/gallery/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GalleryFormController extends GetxController {
  final state = GalleryFormState();
  final ImagePicker _picker = ImagePicker();
  List<String> _originalImages = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is List<String>) {
      _originalImages = List<String>.from(args);
      state.existingImages.addAll(args);
    }
  }

  bool get hasChanges {
    if (state.selectedImages.isNotEmpty) return true;
    if (state.existingImages.length != _originalImages.length) return true;
    for (int i = 0; i < state.existingImages.length; i++) {
      if (state.existingImages[i] != _originalImages[i]) return true;
    }
    return false;
  }

  int get totalCount =>
      state.existingImages.length + state.selectedImages.length;

  int get remaining => GalleryFormState.maxImages - totalCount;

  Future<void> pickFromGallery() async {
    if (remaining <= 0) {
      AppSnackbar.error(
        title: 'Limit Reached',
        message: 'You can add up to ${GalleryFormState.maxImages} images',
      );
      return;
    }

    final List<XFile> picked = await _picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (picked.isEmpty) return;

    _processPickedFiles(picked);
  }

  Future<void> pickFromCamera() async {
    if (remaining <= 0) {
      AppSnackbar.error(
        title: 'Limit Reached',
        message: 'You can add up to ${GalleryFormState.maxImages} images',
      );
      return;
    }

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (picked == null) return;

    _processPickedFiles([picked]);
  }

  void _processPickedFiles(List<XFile> files) {
    int added = 0;
    for (final xFile in files) {
      if (totalCount + added >= GalleryFormState.maxImages) {
        AppSnackbar.error(
          title: 'Limit Reached',
          message:
              'Only ${GalleryFormState.maxImages} images allowed. Some images were skipped.',
        );
        break;
      }

      final file = File(xFile.path);
      final size = file.lengthSync();

      if (size > GalleryFormState.maxFileSizeBytes) {
        AppSnackbar.error(
          title: 'File Too Large',
          message: '${xFile.name} exceeds 5MB limit and was skipped',
        );
        continue;
      }

      final ext = xFile.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
        AppSnackbar.error(
          title: 'Invalid Format',
          message: '${xFile.name} is not a supported image format',
        );
        continue;
      }

      state.selectedImages.add(file);
      added++;
    }
  }

  void removeNewImage(int index) {
    state.selectedImages.removeAt(index);
  }

  void removeExistingImage(int index) {
    state.existingImages.removeAt(index);
  }

  void showPickerOptions() {
    final context = Get.context!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Take Photo', style: TextStyle(color: textColor)),
              onTap: () {
                Get.back();
                pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections, color: Colors.blue),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                Get.back();
                pickFromGallery();
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveGallery() async {
    state.isSaving.value = true;

    try {
      final uploadedUrls = <String>[];

      for (final image in state.selectedImages) {
        final url = await UserProfileApi.uploadFile(image);
        uploadedUrls.add(url);
      }

      final allImages = [...state.existingImages, ...uploadedUrls];

      await UserProfileApi.updateUserProfile({'galleryImages': allImages});
    } on DioException catch (err) {
      state.isSaving.value = false;
      final statusCode = err.response?.statusCode;
      if (statusCode == 401) {
        UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
        return;
      }
      ApiErrorHandler.handleError(err, 'Failed to update gallery');
      return;
    } catch (err) {
      state.isSaving.value = false;
      AppSnackbar.error(
        title: 'Failed',
        message: 'Something went wrong. Please try again.',
      );
      return;
    }

    state.isSaving.value = false;
    Navigator.of(Get.context!).pop('refresh');
    Future.delayed(const Duration(milliseconds: 300), () {
      AppSnackbar.success(
        title: 'Success',
        message: 'Gallery updated successfully',
      );
    });
  }
}
