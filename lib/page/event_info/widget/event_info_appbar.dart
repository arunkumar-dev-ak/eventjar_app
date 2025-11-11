import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/widget/event_info_back_button.dart';
import 'package:eventjar/global/utils/helpers.dart'; // for withValues extension
import 'package:eventjar/page/event_info/widget/event_info_page.utils.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoAppBar extends StatelessWidget {
  final EventInfoController controller = Get.find();

  EventInfoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return EventInfoAppBarShimmer();
      }

      final imageUrl = controller.state.eventInfo.value?.featuredImageUrl;
      // Attendee info
      final int attendedCount =
          controller.state.eventInfo.value?.currentAttendees ?? 0;
      final int maxAttendees =
          controller.state.eventInfo.value?.maxAttendees ?? 0;
      final int spotsLeft = maxAttendees - attendedCount;
      return Container(
        height: 25.hp,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Image.network(
                getFileUrl(imageUrl),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return eventInfoAppBarImageShimmer();
                },
                errorBuilder: (context, error, stackTrace) {
                  return eventInfoAppBarImageNotFound();
                },
              )
            else
              eventInfoAppBarImageNotFound(),

            Container(
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

            // attendee count and seats - bottom left
            SafeArea(
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
