import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/global/utils/helpers.dart';
import 'package:eventjar_app/page/home/widget/home_content_shimmer.dart';
import 'package:eventjar_app/page/home/widget/home_content_utils.dart';
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
              child: Padding(
                padding: EdgeInsets.all(2.wp),
                child: Container(
                  margin: EdgeInsets.only(top: 1.hp),
                  padding: EdgeInsets.all(3.wp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientDarkStart.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image with fallback
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            (event.featuredImageUrl != null &&
                                event.featuredImageUrl!.isNotEmpty)
                            ? Image.network(
                                getFileUrl(event.featuredImageUrl!),
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  // if (loadingProgress == null) return child;
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
                      SizedBox(height: 2.hp),

                      // Title
                      Text(
                        event.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.hp),

                      // Location (City)
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red[300]),
                          SizedBox(width: 1.wp),
                          Expanded(
                            child: Text(
                              (event.city != null && event.city!.isNotEmpty)
                                  ? event.city!
                                  : "No city info",
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.85),
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),

                      // Date & Time
                      Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.blue[300]),
                          SizedBox(width: 1.wp),
                          Expanded(
                            child: Text(
                              '${event.startDate.day.toString().padLeft(2, '0')}-${event.startDate.month.toString().padLeft(2, '0')}-${event.startDate.year} • ${event.startTime}',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.85),
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),

                      // Description
                      Text(
                        event.description,
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.hp),

                      // Tags
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (event.isVirtual)
                              homeContentBuildVirtualTags(label: "Virtual"),
                            if (event.isVirtual) SizedBox(width: 2.wp),
                            homeContentBuildTags(
                              label: event.isPaid ? "Paid" : "Free Entry",
                            ),
                            if (event.category != null) ...[
                              SizedBox(width: 2.wp),
                              homeContentBuildTags(label: event.category!.name),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 1.hp),

                      // Account & Free/Paid Button
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.account_circle, color: Colors.grey),
                                SizedBox(width: 1.wp),
                                Text(
                                  event.organizer.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3.wp),
                          homeContentPaidOrFreeButton(
                            label: event.isPaid ? "Paid" : "Free",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return controller.state.meta.value != null &&
                    controller.state.meta.value!.hasNext == true
                ? const EventCardShimmer()
                : SizedBox();
          }
        }, childCount: controller.state.events.length + 1),
      );
    });
  }
}
