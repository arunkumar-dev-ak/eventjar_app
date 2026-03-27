import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/controller/event_info/extension/event_info_extension.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/model/event_info/event_info_media_extension_model.dart';
import 'package:eventjar/page/event_info/tabs/agenda/agenda_page.dart';
import 'package:eventjar/page/event_info/tabs/organizer/organizer_page.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
            SizedBox(height: 1.5.hp),
            // Event Name
            _buildEventName(),
            SizedBox(height: 1.hp),
            // Organiser Row
            _buildOrganizerRow(eventInfo),
            SizedBox(height: 1.5.hp),
            // Quick Info Row
            _buildQuickInfoRow(eventInfo),
          ],
        ),
      );
    });
  }

  Widget _buildEventName() {
    return Obx(() {
      final isLoading = controller.state.isLoading.value;

      if (isLoading) {
        return EventInfoEventNameShimmer();
      }

      final eventInfo = controller.state.eventInfo.value;

      return Container(
        color: Colors.white,
        width: double.infinity,
        child: Text(
          eventInfo?.title ?? 'Event Details',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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

            // Price badge - top right (only when not 1:1)
            if (!eventInfo.isOneMeetingEnabled)
              Positioned(
                top: 12,
                right: 12,
                child: _buildPriceBadge(eventInfo),
              ),

            // 1:1 badge - bottom right
            if (eventInfo.isOneMeetingEnabled)
              Positioned(bottom: 12, right: 12, child: _buildOneOnOneBadge()),
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

  // Widget _buildModeBadge({required bool isVirtual, required bool isHybrid}) {
  //   IconData icon;
  //   String label;
  //   List<Color> colors;

  //   if (isHybrid) {
  //     icon = Icons.sync_alt_rounded;
  //     label = 'Hybrid';
  //     colors = [Colors.purple.shade400, Colors.purple.shade600];
  //   } else if (isVirtual) {
  //     icon = Icons.videocam_rounded;
  //     label = 'Virtual';
  //     colors = [Colors.blue.shade400, Colors.blue.shade600];
  //   } else {
  //     icon = Icons.place_rounded;
  //     label = 'In-Person';
  //     colors = [Colors.green.shade400, Colors.green.shade600];
  //   }

  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(colors: colors),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: colors[0].withValues(alpha: 0.4),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, color: Colors.white, size: 16),
  //         const SizedBox(width: 6),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 9.sp,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _formatAttendeeCount(int count) {
    if (count <= 0) return '0';
    if (count < 10) return '$count+';
    final rounded = (count ~/ 10) * 10;
    return '$rounded+';
  }

  Widget _buildOrganizerRow(EventInfo eventInfo) {
    final organizer = eventInfo.organizer;
    final count = eventInfo.attendeeCount;
    final hasAvatar =
        organizer.avatarUrl != null && organizer.avatarUrl!.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.2.hp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // ── Organiser section (tap → organiser popup) ──────────────
          Expanded(
            child: InkWell(
              onTap: () => showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.4,
                  maxChildSize: 0.95,
                  expand: false,
                  builder: (_, scrollController) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: OrganizerPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.deepPurple.shade100,
                    backgroundImage: hasAvatar
                        ? NetworkImage(getFileUrl(organizer.avatarUrl!))
                        : null,
                    child: hasAvatar
                        ? null
                        : Text(
                            organizer.name.isNotEmpty
                                ? organizer.name[0].toUpperCase()
                                : 'O',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                  ),
                  SizedBox(width: 2.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Organised by',
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          organizer.name,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
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
          ),

          SizedBox(width: 2.wp),

          // ── Attendee count section (tap → attendees tab) ────────────
          if (controller.canShowAttendeesTab)
            GestureDetector(
              onTap: () {
                controller.tabControllerRx.value?.animateTo(1);
              },
              child: Obx(() {
                final attendees =
                    controller.state.attendeeList.value?.attendees ?? [];
                final preview = attendees.take(3).toList();
                final fallbackColors = [
                  Colors.blue.shade200,
                  Colors.green.shade300,
                  Colors.orange.shade300,
                ];

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 26,
                      width: 72,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ...List.generate(3, (i) {
                            final hasAttendee = i < preview.length;
                            final attendee = hasAttendee ? preview[i] : null;
                            final hasAttendeeAvatar =
                                attendee?.avatarUrl != null &&
                                attendee!.avatarUrl!.isNotEmpty;
                            return Positioned(
                              left: i * 16.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 13,
                                  backgroundColor: fallbackColors[i],
                                  backgroundImage: hasAttendeeAvatar
                                      ? NetworkImage(
                                          getFileUrl(attendee.avatarUrl ?? ''),
                                        )
                                      : null,
                                  child: hasAttendeeAvatar
                                      ? null
                                      : (hasAttendee
                                            ? Text(
                                                attendee!.name.isNotEmpty
                                                    ? attendee.name[0]
                                                          .toUpperCase()
                                                    : '?',
                                                style: TextStyle(
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: 13,
                                                color: Colors.white,
                                              )),
                                ),
                              ),
                            );
                          }),
                          // Count badge
                          Positioned(
                            left: 48,
                            child: Container(
                              height: 26,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple.shade400,
                                    Colors.deepPurple.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _formatAttendeeCount(count),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 1.wp),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }

  Future<void> _launchLocation(EventInfo eventInfo) async {
    if (eventInfo.isVirtual) {
      final link = eventInfo.virtualLink;
      if (link == null || link.isEmpty) {
        Get.snackbar(
          'No Link',
          'No meeting link available for this event.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      final normalised =
          link.startsWith('http://') || link.startsWith('https://')
          ? link
          : 'https://$link';
      final uri = Uri.tryParse(normalised);
      if (uri == null || !await canLaunchUrl(uri)) {
        Get.snackbar(
          'Invalid Link',
          'Could not open the meeting link. Please check the link and try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final lat = eventInfo.latitude;
      final lng = eventInfo.longitude;
      final venue = eventInfo.venue ?? '';
      Uri uri;
      if (lat != null && lng != null) {
        uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
        );
      } else if (venue.isNotEmpty) {
        uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(venue)}',
        );
      } else {
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
            child: InkWell(
              onTap: () => showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.4,
                  maxChildSize: 0.95,
                  expand: false,
                  builder: (_, scrollController) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: AgendaPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                              color: Colors.orange.shade700,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.orange.shade700,
                            ),
                          ),
                          Text(
                            'Tap to view agenda',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 8.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          SizedBox(width: 4.wp),
          // Location preview
          Expanded(
            child: InkWell(
              onTap: () => _launchLocation(eventInfo),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                              color: eventInfo.isVirtual
                                  ? Colors.blue.shade600
                                  : Colors.red.shade600,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: eventInfo.isVirtual
                                  ? Colors.blue.shade600
                                  : Colors.red.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            eventInfo.isVirtual ? 'Tap to join' : 'Tap to View',
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
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
