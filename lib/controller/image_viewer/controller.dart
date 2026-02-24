import 'dart:io';
import 'package:eventjar/controller/image_viewer/state.dart';
import 'package:get/get.dart';

class ImageViewerController extends GetxController {
  var state = ImageViewerState();

  @override
  void onInit() {
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final file = args["file"] as File?;
      final fileUrl = args["fileUrl"] as String?;
      final header = args["header"] as String?;

      if (file != null) {
        state.selectedImage.value = file;
      }

      if (fileUrl != null && fileUrl.isNotEmpty) {
        state.imageUrl.value = fileUrl;
      }

      state.header.value = header ?? "";
    }

    super.onInit();
  }
}
