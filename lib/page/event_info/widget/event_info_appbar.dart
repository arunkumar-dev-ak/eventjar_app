import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/page/event_info/widget/event_info_back_button.dart';
import 'package:eventjar/page/event_info/widget/event_info_page.utils.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:eventjar/model/event_info/event_info_media_extension_model.dart';

class EventInfoAppBar extends StatelessWidget {
  final EventInfoController controller = Get.find();

  EventInfoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return EventInfoAppBarShimmer();
      }

      final eventInfo = controller.state.eventInfo.value;
      final List<Media> mediaImages = eventInfo?.media ?? [];

      // Attendee info
      final int attendedCount =
          controller.state.eventInfo.value?.currentAttendees ?? 0;
      final int maxAttendees =
          controller.state.eventInfo.value?.maxAttendees ?? 0;

      return Container(
        height: 25.hp,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Carousel slider for gallery images in app bar
            CarouselSlider(
              carouselController: controller.carouselSliderController,
              options: CarouselOptions(
                height: 25.hp,
                viewportFraction: 1,
                enableInfiniteScroll: mediaImages.length > 1,
                autoPlay: mediaImages.length > 1,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: Duration(seconds: 10),
                enlargeCenterPage: false,
              ),
              items: eventInfo?.media.map((m) {
                return Builder(
                  builder: (BuildContext context) {
                    if (m.isYouTube) {
                      return InkWell(
                        onTap: () => controller.openYoutube(
                          m.resolvedUrl,
                        ), // ensure you have this field
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              m.youtubeThumbnail,
                              fit: BoxFit.cover,
                            ),
                            const Icon(
                              Icons.play_circle_fill,
                              size: 60,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CachedNetworkImage(
                        imageUrl: m.resolvedUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            eventInfoAppBarImageShimmer(),
                        errorWidget: (context, url, error) =>
                            eventInfoAppBarImageNotFound(),

                        // 👇 This forces memory-only caching (no disk cache)
                        cacheManager: CacheManager(
                          Config(
                            "memoryCache",
                            stalePeriod: const Duration(minutes: 30),
                            maxNrOfCacheObjects: 100,
                            repo: JsonCacheInfoRepository(
                              databaseName: null,
                            ), // no database → no disk
                            fileService: HttpFileService(),
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),

            //gradient overlay
            IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // attendee count and seats - bottom left
            IgnorePointer(
              ignoring: true,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.wp,
                      vertical: 1.wp,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "$attendedCount Attendees",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.event_seat, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            maxAttendees > 0
                                ? "$maxAttendees Seats"
                                : "Seats N/A",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 0),
                  child: EventInfoBackButton(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
