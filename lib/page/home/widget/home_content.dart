import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/helper/event_share_helper.dart';

import 'package:eventjar/page/home/widget/home_content_shimmer.dart';
import 'package:eventjar/page/home/widget/home_content_utils.dart';
import 'package:eventjar/global/app_colors.dart';
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
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // EVENT CATEGORIES title + category chips
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.wp,
                      vertical: 1.5.hp,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Event Categories',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    final categories = controller.state.eventCategories;
                    final showViewAll = categories.length > 3;
                    final displayed = showViewAll
                        ? categories.take(4).toList()
                        : categories.toList();
                    return SizedBox(
                      height: 4.hp,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 4.wp),
                        children: [
                          ...displayed.map(
                            (c) => _buildCategoryChip(
                              c.name ?? '',
                              const Color(0xFF1A73E8),
                            ),
                          ),
                          if (showViewAll)
                            _buildCategoryChip('View All', Colors.grey),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 1.hp),
                ],
              );
            }

            // EVENTS title + View All
            if (index == 1) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.wp,
                  vertical: 1.5.hp,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Events',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.navigateToEventCategoryPage();
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A73E8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final events = controller.state.events;
            final displayCount = events.length > 5 ? 5 : events.length;
            final eventIndex = index - 2;
            if (eventIndex < displayCount) {
              final event = events[eventIndex];
              // Determine event type
              final (
                String typeLabel,
                IconData typeIcon,
                Color typeColor,
              ) = event.isHybrid
                  ? ('Hybrid', Icons.swap_horiz, const Color(0xFFFF8F00))
                  : event.isVirtual
                  ? ('Online', Icons.videocam, const Color(0xFF1A73E8))
                  : ('Physical', Icons.location_on, const Color(0xFF4CAF50));

              return GestureDetector(
                onTap: () => controller.navigateToEventInfoPage(event),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 4.wp,
                    vertical: 1.hp,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardElevatedBg(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Theme.of(context).brightness == Brightness.dark
                        ? Border.all(
                            color: AppColors.border(context),
                            width: 0.8,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow(context),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event image with share button overlay
                      Stack(
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            color: AppColors.chipBg(context),
                            child:
                                (event.featuredImageUrl != null &&
                                    event.featuredImageUrl!.isNotEmpty)
                                ? Image.network(
                                    (event.featuredImageUrl!.contains(
                                              'cdn.myeventjar.com',
                                            ) ||
                                            event.featuredImageUrl!.startsWith(
                                              'http',
                                            ))
                                        ? event.featuredImageUrl!
                                        : getFileUrl(event.featuredImageUrl!),
                                    width: double.infinity,
                                    height: 160,
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
                          // Share button — top right
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
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
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg(context),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.share_rounded,
                                  size: 20,
                                  color: const Color(0xFF1A73E8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Event title
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.wp, 1.5.hp, 3.wp, 0),
                        child: Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Date/time (left) + Online & Paid badges (right)
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.wp, 1.2.hp, 3.wp, 0),
                        child: Row(
                          children: [
                            // Date & time — left
                            Icon(
                              Icons.calendar_today,
                              size: 11,
                              color: const Color(0xFF1A73E8),
                            ),
                            SizedBox(width: 1.wp),
                            Expanded(
                              child: Text(
                                controller.formatEventDateTimeForHome(
                                  event,
                                  context,
                                ),
                                style: TextStyle(
                                  fontSize: 7.5.sp,
                                  color: const Color(0xFF1A73E8),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 2.wp),
                            // Event type badge — right
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.wp,
                                vertical: 0.4.hp,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(typeIcon, size: 11, color: typeColor),
                                  SizedBox(width: 0.8.wp),
                                  Text(
                                    typeLabel,
                                    style: TextStyle(
                                      color: typeColor,
                                      fontSize: 7.5.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 1.wp),
                            // Free / Paid badge — right
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.wp,
                                vertical: 0.4.hp,
                              ),
                              decoration: BoxDecoration(
                                color: event.isPaid
                                    ? const Color(
                                        0xFFE65100,
                                      ).withValues(alpha: 0.1)
                                    : const Color(
                                        0xFF388E3C,
                                      ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                event.isPaid ? 'Paid' : 'Free',
                                style: TextStyle(
                                  color: event.isPaid
                                      ? const Color(0xFFE65100)
                                      : const Color(0xFF388E3C),
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Venue (for physical / hybrid events)
                      if (!event.isVirtual &&
                          (event.city?.isNotEmpty == true ||
                              event.venue?.isNotEmpty == true))
                        Padding(
                          padding: EdgeInsets.fromLTRB(3.wp, 1.hp, 3.wp, 0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: const Color(0xFFE65100),
                              ),
                              SizedBox(width: 1.wp),
                              Expanded(
                                child: Text(
                                  event.venue ?? event.city ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 8.5.sp,
                                    color: const Color(0xFFE65100),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Description
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.wp, 1.2.hp, 3.wp, 0),
                        child: Text(
                          event.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: AppColors.textHint(context),
                            height: 1.3,
                          ),
                        ),
                      ),

                      // Organiser + arrow
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          3.wp,
                          1.2.hp,
                          3.wp,
                          1.5.hp,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Organized by',
                                    style: TextStyle(
                                      fontSize: 7.sp,
                                      color: AppColors.textHint(context),
                                    ),
                                  ),
                                  SizedBox(height: 0.3.hp),
                                  Text(
                                    event.organizer.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 8.5.sp,
                                      color: AppColors.textPrimary(context),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.hp),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              if (events.length > 5) {
                return GestureDetector(
                  onTap: () => controller.navigateToEventCategoryPage(),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.wp,
                      vertical: 1.hp,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.8.hp),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A73E8).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1A73E8).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View All Events',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A73E8),
                          ),
                        ),
                        SizedBox(width: 2.wp),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: const Color(0xFF1A73E8),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            }
          },
          childCount:
              (controller.state.events.length > 5
                  ? 5
                  : controller.state.events.length) +
              3,
        ),
      );
    });
  }

  Widget _buildCategoryChip(String label, Color color) {
    return GestureDetector(
      onTap: () {
        controller.navigateToEventCategoryPage(
          category: label == 'View All' ? null : label,
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 2.wp),
        padding: EdgeInsets.symmetric(horizontal: 4.wp),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
