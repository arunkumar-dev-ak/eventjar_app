import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/model/event_info/event_info_media_extension_model.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class EventInfoHeader extends StatelessWidget {
  final EventInfoController controller = Get.find();

  EventInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return EventInfoHeaderShimmer(); // Improved shimmer matching app bar
      }

      final eventInfo = controller.state.eventInfo.value;
      if (eventInfo == null) {
        return const SizedBox();
      }

      final List<Media> mediaImages = eventInfo.media;

      return Container(
        padding: EdgeInsets.all(4.wp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Event Images (like your app bar)
            _buildEventImageCarousel(eventInfo, mediaImages),
            SizedBox(height: 2.hp),

            // Quick Info Row (unchanged)
            _buildQuickInfoRow(eventInfo),
          ],
        ),
      );
    });
  }

  Widget _buildEventImageCarousel(
    EventInfo eventInfo,
    List<Media> mediaImages,
  ) {
    return Container(
      width: double.infinity,
      height: 28.hp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Carousel slider for multiple images (like your app bar)
            CarouselSlider(
              carouselController: controller.carouselSliderController,
              options: CarouselOptions(
                height: 28.hp,
                viewportFraction: 1,
                enableInfiniteScroll: mediaImages.length > 1,
                autoPlay: mediaImages.length > 1,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: Duration(seconds: 10),
                enlargeCenterPage: false,
              ),
              items: mediaImages.map((m) {
                return Builder(
                  builder: (BuildContext context) {
                    if (m.isYouTube) {
                      return InkWell(
                        onTap: () => controller.openYoutube(m.resolvedUrl),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: m.youtubeThumbnail,
                              fit: BoxFit.cover,
                              cacheManager: _getMemoryCacheManager(),
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black26,
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CachedNetworkImage(
                        imageUrl: m.resolvedUrl,
                        fit: BoxFit.cover,
                        cacheManager: _getMemoryCacheManager(),
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            _buildImagePlaceholder(),
                      );
                    }
                  },
                );
              }).toList(),
            ),

            // Gradient overlay (matching your app bar)
            IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Mode badge - top left
            // Positioned(
            //   top: 12,
            //   left: 12,
            //   child: _buildModeBadge(
            //     isVirtual: eventInfo.isVirtual,
            //     isHybrid: eventInfo.isHybrid,
            //   ),
            // ),

            // Price badge - top right
            Positioned(
              top: 12,
              right: 12,
              child: eventInfo.isOneMeetingEnabled
                  ? _buildOneOnOneBadge()
                  : _buildPriceBadge(eventInfo),
            ),

            // Stats at bottom (matching your app bar style)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  _buildImageStat(
                    icon: Icons.people_alt_rounded,
                    label: '${eventInfo.currentAttendees} Attending',
                  ),
                  SizedBox(width: 3.wp),
                  _buildImageStat(
                    icon: Icons.event_seat_rounded,
                    label: eventInfo.maxAttendees > 0
                        ? '${eventInfo.maxAttendees} Seats'
                        : 'Unlimited',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CacheManager _getMemoryCacheManager() {
    return CacheManager(
      Config(
        "memoryCache",
        stalePeriod: const Duration(minutes: 30),
        maxNrOfCacheObjects: 100,
        repo: JsonCacheInfoRepository(databaseName: null), // no disk cache
        fileService: HttpFileService(),
      ),
    );
  }

  Widget _buildOneOnOneBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '1 : 1',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(EventInfo eventInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: eventInfo.isPaid ? Colors.white : Colors.green,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        eventInfo.isPaid ? '\$${eventInfo.ticketPrice ?? 'Paid'}' : 'FREE',
        style: TextStyle(
          color: eventInfo.isPaid ? Colors.grey.shade800 : Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Rest of your existing methods unchanged...
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageStat({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gradientDarkStart, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeBadge({required bool isVirtual, required bool isHybrid}) {
    IconData icon;
    String label;
    List<Color> colors;

    if (isHybrid) {
      icon = Icons.sync_alt_rounded;
      label = 'Hybrid';
      colors = [Colors.purple.shade400, Colors.purple.shade600];
    } else if (isVirtual) {
      icon = Icons.videocam_rounded;
      label = 'Virtual';
      colors = [Colors.blue.shade400, Colors.blue.shade600];
    } else {
      icon = Icons.place_rounded;
      label = 'In-Person';
      colors = [Colors.green.shade400, Colors.green.shade600];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoRow(EventInfo eventInfo) {
    // Format date display
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final startDate = eventInfo.startDate;

    final dateStr =
        '${startDate.day} ${months[startDate.month - 1]}, ${startDate.year}';
    final timeStr = eventInfo.startTime.isNotEmpty
        ? controller.generateDateTimeAndFormatTime(
            eventInfo.startTime,
            Get.context!,
          )
        : 'Time TBA';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date & Time
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.orange.shade600,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          SizedBox(width: 4.wp),
          // Location preview
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (eventInfo.isVirtual ? Colors.blue : Colors.red)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    eventInfo.isVirtual
                        ? Icons.language_rounded
                        : Icons.location_on_rounded,
                    color: eventInfo.isVirtual
                        ? Colors.blue.shade600
                        : Colors.red.shade600,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventInfo.isVirtual
                            ? 'Online'
                            : (eventInfo.city ?? 'Location'),
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        eventInfo.isVirtual
                            ? 'Virtual Event'
                            : (eventInfo.venue ?? 'Venue TBA'),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 8.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
