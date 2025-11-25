import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagesPage extends StatelessWidget {
  final EventInfoController controller = Get.find();

  ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final eventInfo = controller.state.eventInfo.value;

      if (eventInfo == null) {
        return const Center(child: Text("No event info available"));
      }

      final images = eventInfo.galleryImages;

      if (images.isEmpty) {
        return _buildNoImagesView();
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(3.wp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 3.wp),
                  child: _buildImageCard(images[index], index),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  // Image card with gradient border
  Widget _buildImageCard(String imageUrl, int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  getFileUrl(imageUrl),
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gradientDarkStart,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 1.hp),
                            Text(
                              "Failed to load image",
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Image caption
              Padding(
                padding: EdgeInsets.all(3.wp),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.wp,
                        vertical: 0.5.hp,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Image ${index + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// No images placeholder
  Widget _buildNoImagesView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.wp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withOpacity(0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 70,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.hp),
            Text(
              "No Images Yet",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.5.hp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.wp),
              child: Text(
                "Gallery images will be available soon. Check back later!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
