import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/page/event_info/widget/event_info_back_button.dart';
import 'package:eventjar_app/global/utils/helpers.dart'; // for withValues extension
import 'package:eventjar_app/page/event_info/widget/event_info_page.utils.dart';
import 'package:eventjar_app/page/event_info/widget/event_info_shimmer.dart';
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

      // Use reactive event info's featuredImageUrl if loaded, else fallback URL
      final imageUrl = controller.state.eventInfo.value?.featuredImageUrl;
      return Container(
        height: 250,
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

            // gradient overlay
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

            // back button
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
