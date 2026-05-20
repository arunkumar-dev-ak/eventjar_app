import 'dart:io';
import 'package:get/get.dart';

class GalleryFormState {
  final RxList<File> selectedImages = <File>[].obs;
  final RxList<String> existingImages = <String>[].obs;
  final RxBool isSaving = false.obs;

  static const int maxImages = 10;
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB
}
