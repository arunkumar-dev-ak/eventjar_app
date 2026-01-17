import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/helper/event_share_helper.dart';
import 'package:eventjar/page/home/widget/home_content_shimmer.dart';
import 'package:eventjar/page/home/widget/home_content_utils.dart';
import 'package:eventjar/page/home/widget/home_price_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeContent extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const EventCardShimmer(),
            childCount: 4,
          ),
        );
      }
      if (controller.state.events.isEmpty) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: noEventsFoundWidget(),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index < controller.state.events.length) {
            final event = controller.state.events[index];
            return GestureDetector(
              onTap: () => controller.navigateToEventInfoPage(event),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.wp,
                  vertical: 1.5.hp,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.gradientDarkStart.withValues(
                        alpha: 0.04,
                      ),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with overlay elements
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            color: Colors.grey.shade100,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child:
                              (event.featuredImageUrl != null &&
                                  event.featuredImageUrl!.isNotEmpty)
                              ? Image.network(
                                  getFileUrl(event.featuredImageUrl!),
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return homeContentImageShimmer();
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return homeContentImageNotFound();
                                  },
                                )
                              : homeContentImageNotFound(),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (event.category != null)
                          Positioned(
                            bottom: 1,
                            left: 5,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gradientDarkStart.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                event.category!.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            onPressed: () {
                              ShareEventHelper.shareEvent(
                                context: context,
                                title: event.title,
                                slug: event.slug,
                                startDate: event.startDate,
                                startTimeHHMM: event.startTime,
                                mode: event.isHybrid
                                    ? EventMode.hybrid
                                    : event.isVirtual
                                    ? EventMode.virtual
                                    : EventMode.physical,
                                city: event.city,
                                imageUrl:
                                    event.featuredImageUrl != null &&
                                        event.featuredImageUrl!.isNotEmpty
                                    ? getFileUrl(event.featuredImageUrl!)
                                    : null,
                              );
                            },
                            icon: const Icon(Icons.share_rounded),
                            color: Colors.white,
                            iconSize: 18,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withValues(
                                alpha: 0.55,
                              ),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content section
                    Padding(
                      padding: EdgeInsets.all(4.wp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.hp),

                          // Description
                          Text(
                            event.description,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 9.sp,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.5.hp),

                          // Info row with icons
                          Row(
                            children: [
                              // Location
                              Expanded(
                                child: _buildInfoItem(
                                  icon: event.isVirtual
                                      ? Icons.language_rounded
                                      : Icons.location_on_rounded,
                                  text: event.isVirtual
                                      ? 'Virtual Event'
                                      : (event.city?.isNotEmpty == true
                                            ? event.city!
                                            : 'Location TBA'),
                                  iconColor: event.isVirtual
                                      ? Colors.blue.shade400
                                      : Colors.red.shade400,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: Colors.grey.shade200,
                              ),
                              // Time
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons.access_time_rounded,
                                  text: controller.formatEventDateTimeForHome(
                                    event,
                                    context,
                                  ),
                                  iconColor: Colors.orange.shade400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.hp),

                          // Divider
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.grey.shade200,
                                  Colors.grey.shade200,
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.2, 0.8, 1.0],
                              ),
                            ),
                          ),
                          SizedBox(height: 1.5.hp),

                          // Organizer row
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: AppColors.buttonGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    event.organizer.name.isNotEmpty
                                        ? event.organizer.name[0].toUpperCase()
                                        : 'O',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.wp),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Organized by',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                    Text(
                                      event.organizer.name,
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              EventPriceBadge(isPaid: event.isPaid),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return controller.state.meta.value != null &&
                    controller.state.meta.value!.hasNext == true
                ? const EventCardShimmer()
                : const SizedBox();
          }
        }, childCount: controller.state.events.length + 1),
      );
    });
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
