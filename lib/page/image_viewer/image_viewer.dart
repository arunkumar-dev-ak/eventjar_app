import 'package:eventjar/controller/image_viewer/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewerPage extends GetView<ImageViewerController> {
  const ImageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.8),
        title: Obx(
          () => Text(
            controller.state.header.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Obx(() {
        final imageFile = controller.state.selectedImage.value;
        final imageUrl = controller.state.imageUrl.value;

        /// Case 1: Local file
        if (imageFile != null) {
          return Hero(
            tag: imageFile.path,
            child: SizedBox.expand(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: Image.file(imageFile, fit: BoxFit.contain),
                ),
              ),
            ),
          );
        }

        /// Case 2: Network image
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return Hero(
            tag: imageUrl,
            child: SizedBox.expand(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      }),
    );
  }
}
