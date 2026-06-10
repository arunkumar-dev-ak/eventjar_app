import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_shared.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioProfileGalleryCard extends GetView<BioProfileController> {
  const BioProfileGalleryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final images = controller.galleryImages;
    const int columns = 3;
    const int perPage = 6;
    const double spacing = 8;
    final int pageCount = (images.length / perPage).ceil();

    return BioProfileCard(
      icon: Icons.photo_library_outlined,
      title: 'gallery'.tr,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${images.length}',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.gradientDarkStart,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileSize =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final maxRows = (images.length > perPage ? perPage : images.length);
          final rows = (maxRows / columns).ceil();
          final gridHeight = rows * tileSize + (rows - 1) * spacing;

          return Column(
            children: [
              SizedBox(
                height: gridHeight,
                child: PageView.builder(
                  itemCount: pageCount,
                  onPageChanged: (index) {
                    controller.state.galleryIndex.value = index;
                  },
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * perPage;
                    final end = (start + perPage) > images.length
                        ? images.length
                        : start + perPage;
                    final pageImages = images.sublist(start, end);

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            childAspectRatio: 1,
                          ),
                      itemCount: pageImages.length,
                      itemBuilder: (context, index) {
                        final imgIndex = start + index;
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            RouteName.imageViewerPage,
                            arguments: {
                              "fileUrl": getFileUrl(images[imgIndex]),
                              "header": controller.name,
                            },
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: getFileUrl(images[imgIndex]),
                              fit: BoxFit.cover,
                              width: tileSize,
                              height: tileSize,
                              placeholder: (context, url) => Container(
                                color: AppColors.chipBg(context),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.chipBg(context),
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 28,
                                  color: AppColors.iconMuted(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
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
              if (pageCount > 1) ...[
                SizedBox(height: 1.5.hp),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageCount, (index) {
                      final isActive =
                          controller.state.galleryIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? AppColors.gradientDarkStart
                              : AppColors.gradientDarkStart.withValues(
                                  alpha: 0.2,
                                ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
