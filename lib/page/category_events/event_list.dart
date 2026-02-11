import 'package:eventjar/controller/categories_event/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/helper/event_share_helper.dart';
import 'package:eventjar/model/home/home_model.dart';
import 'package:eventjar/page/home/widget/home_content_shimmer.dart';
import 'package:eventjar/page/home/widget/home_content_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final CategoriesEventController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Date filter chip
          Obx(() {
            final filterDate = controller.state.filterDate.value;
            if (filterDate == null) return const SizedBox.shrink();
            return Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(4.wp, 1.hp, 4.wp, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: const Color(0xFF1A73E8),
                  ),
                  SizedBox(width: 1.5.wp),
                  Text(
                    '${filterDate.day}/${filterDate.month}/${filterDate.year}',
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A73E8),
                    ),
                  ),
                  SizedBox(width: 2.wp),
                  GestureDetector(
                    onTap: () => controller.setFilterDate(null),
                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }),
          // Category tabs
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 5.hp,
              child: Obx(() {
                final selectedTab = controller.state.selectedTab.value;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.wp),
                  itemCount: CategoriesEventController.categoryTabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: 5.wp),
                  itemBuilder: (context, index) {
                    final tab = CategoriesEventController.categoryTabs[index];
                    final isSelected = selectedTab == index;
                    return GestureDetector(
                      onTap: () => controller.setSelectedTab(index),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: isSelected
                              ? Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF1A73E8),
                                    width: 2.5,
                                  ),
                                )
                              : null,
                        ),
                        padding: EdgeInsets.only(bottom: 0.5.hp),
                        child: Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : Colors.grey[500],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          // Event list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return ListView.builder(
                  padding: EdgeInsets.all(4.wp),
                  itemCount: 4,
                  itemBuilder: (_, __) => const EventCardShimmer(),
                );
              }

              final events = controller.filteredEvents;

              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event_busy_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 2.hp),
                      Text(
                        'No events found',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.all(4.wp),
                itemCount: events.length + 1,
                itemBuilder: (context, index) {
                  if (index < events.length) {
                    return _buildEventCard(context, events[index]);
                  }
                  // Pagination shimmer
                  return controller.state.meta.value != null &&
                          controller.state.meta.value!.hasNext == true
                      ? const EventCardShimmer()
                      : const SizedBox();
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(() {
        final isSearching = controller.state.isSearching.value;
        return AppBar(
          title:
              // isSearching
              //     ? TextField(
              //         controller: controller.searchController,
              //         autofocus: true,
              //         decoration: InputDecoration(
              //           hintText: 'Search events...',
              //           hintStyle: TextStyle(
              //             color: Colors.grey[400],
              //             fontSize: 10.sp,
              //           ),
              //           border: InputBorder.none,
              //         ),
              //         style: TextStyle(color: Colors.black, fontSize: 10.sp),
              //         onChanged: controller.onSearchChanged,
              //       )
              //     :
              Text(
                'Events',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
          centerTitle: !isSearching,
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (isSearching) {
                controller.toggleSearch();
              } else {
                Get.back();
              }
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appBarGradient),
          ),

          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       isSearching ? Icons.close : Icons.search,
          //       color: Colors.black,
          //     ),
          //     onPressed: controller.toggleSearch,
          //   ),
          //   Obx(() {
          //     final hasFilter = controller.state.filterDate.value != null;
          //     return IconButton(
          //       icon: Icon(
          //         Icons.filter_list,
          //         color: hasFilter ? const Color(0xFF1A73E8) : Colors.black,
          //       ),
          //       onPressed: () async {
          //         final picked = await showDatePicker(
          //           context: context,
          //           initialDate:
          //               controller.state.filterDate.value ?? DateTime.now(),
          //           firstDate: DateTime(2024, 1, 1),
          //           lastDate: DateTime(2027, 12, 31),
          //         );
          //         controller.setFilterDate(picked);
          //       },
          //     );
          //   }),
          // ],
        );
      }),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
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
        margin: EdgeInsets.only(bottom: 1.5.hp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
                  color: Colors.grey.shade100,
                  child:
                      (event.featuredImageUrl != null &&
                          event.featuredImageUrl!.isNotEmpty)
                      ? Image.network(
                          (event.featuredImageUrl!.contains(
                                    'cdn.myeventjar.com',
                                  ) ||
                                  event.featuredImageUrl!.startsWith('http'))
                              ? event.featuredImageUrl!
                              : getFileUrl(event.featuredImageUrl!),
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
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
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
              ),
            ),

            // Date/time (left) + Online & Paid badges (right)
            Padding(
              padding: EdgeInsets.fromLTRB(3.wp, 1.2.hp, 3.wp, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 11,
                    color: const Color(0xFF1A73E8),
                  ),
                  SizedBox(width: 1.wp),
                  Expanded(
                    child: Text(
                      controller.formatEventDateTime(event, context),
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
                  // Event type badge
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
                  // Free / Paid badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.wp,
                      vertical: 0.4.hp,
                    ),
                    decoration: BoxDecoration(
                      color: event.isPaid
                          ? const Color(0xFFE65100).withValues(alpha: 0.1)
                          : const Color(0xFF388E3C).withValues(alpha: 0.1),
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
                  color: Colors.grey[500],
                  height: 1.3,
                ),
              ),
            ),

            // Organiser + arrow
            Padding(
              padding: EdgeInsets.fromLTRB(3.wp, 1.2.hp, 3.wp, 1.5.hp),
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
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 0.3.hp),
                        Text(
                          event.organizer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: Colors.black,
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
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
