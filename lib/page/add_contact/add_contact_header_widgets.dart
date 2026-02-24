import 'dart:async';
import 'dart:io';
import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactImagePreview extends GetView<AddContactController> {
  const AddContactImagePreview({super.key});

  Future<Size> _getImageSize(File file) async {
    final decodedImage = await decodeImageFromList(await file.readAsBytes());
    return Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  }

  Future<Size> _getNetworkImageSize(String url) async {
    final completer = Completer<Size>();
    final image = NetworkImage(url);

    image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            final myImage = info.image;
            completer.complete(
              Size(myImage.width.toDouble(), myImage.height.toDouble()),
            );
          }),
        );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imageFile = controller.state.selectedImage.value;
      final imageUrl = controller.state.existingImageUrl.value;

      if (imageFile != null) {
        return _buildFilePreview(imageFile);
      }

      /// Case 2: Existing network image
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return _buildNetworkPreview(imageUrl);
      }

      return const SizedBox();
    });
  }

  Widget _buildFilePreview(File imageFile) {
    return FutureBuilder<Size>(
      future: _getImageSize(imageFile),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final size = snapshot.data!;
        final isPortrait = size.height > size.width;

        return Column(
          children: [
            GestureDetector(
              onTap: controller.navigateToImageViewer,
              child: Hero(
                tag: imageFile.path,
                child: Container(
                  width: double.infinity,
                  height: isPortrait ? 40.hp : 25.hp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(imageFile, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.hp),
          ],
        );
      },
    );
  }

  Widget _buildNetworkPreview(String imageUrl) {
    return FutureBuilder<Size>(
      future: _getNetworkImageSize(imageUrl),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final size = snapshot.data!;
        final isPortrait = size.height > size.width;

        return Column(
          children: [
            GestureDetector(
              onTap: controller.navigateToImageViewer,
              child: Hero(
                tag: imageUrl,
                child: Container(
                  width: double.infinity,
                  height: isPortrait ? 40.hp : 25.hp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.hp),
          ],
        );
      },
    );
  }
}

class AddContactImageToggle extends GetView<AddContactController> {
  const AddContactImageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imageFile = controller.state.selectedImage.value;

      if (imageFile == null) {
        return const SizedBox();
      }

      final isDisabled = controller.state.hideToogle.value;

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isDisabled ? 0.6 : 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDisabled ? Colors.red.shade200 : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Top Row
              Row(
                children: [
                  Container(
                    height: 5.hp,
                    width: 5.hp,
                    decoration: BoxDecoration(
                      color: isDisabled
                          ? Colors.red.shade50
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: isDisabled
                          ? Colors.red.shade400
                          : Colors.blue.shade700,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 3.wp),

                  /// Text section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Contact with Visting Card",
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(height: 0.5.hp),
                        // Text(
                        //   "Attach a profile image for this contact",
                        //   style: TextStyle(
                        //     fontSize: 7.5.sp,
                        //     color: Colors.grey.shade600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  /// 🔹 Switch
                  Switch(
                    value: isDisabled
                        ? false
                        : controller.state.addWithImage.value,
                    activeThumbColor: Colors.blue.shade700,
                    onChanged: isDisabled
                        ? null
                        : (value) {
                            controller.state.addWithImage.value = value;
                          },
                  ),
                ],
              ),

              /// 🔹 Warning section (only when disabled)
              if (isDisabled) ...[
                SizedBox(height: 1.5.hp),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade400,
                      size: 16,
                    ),
                    SizedBox(width: 2.wp),
                    Expanded(
                      child: Text(
                        "You can’t send image because it is greater than 5 MB.",
                        style: TextStyle(
                          fontSize: 7.5.sp,
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
