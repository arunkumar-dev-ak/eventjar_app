import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverViewPage extends StatelessWidget {
  final EventInfoController controller = Get.find();

  OverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final eventInfo = controller.state.eventInfo.value;
      if (eventInfo == null) {
        return const SizedBox();
      }

      final List<String> tags = [];
      if (eventInfo.category != null && eventInfo.category!.name != null) {
        tags.add(eventInfo.category!.name!);
      }
      // Add event tags
      tags.addAll(eventInfo.tags);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.5.hp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.wp),
            child: Text(
              eventInfo.description ??
                  "No description available for this event.",
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 2.hp),
        ],
      );
    });
  }
}
