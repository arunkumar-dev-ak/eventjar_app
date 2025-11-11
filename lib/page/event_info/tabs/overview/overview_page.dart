import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
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

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.5.hp),
            // Tags Horizontal Scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tags.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 5.wp : 2.wp),
                    child: _buildTags(label: tags[index]),
                  );
                }),
              ),
            ),
            SizedBox(height: 1.hp),
            Padding(
              padding: EdgeInsets.only(left: 5.wp, right: 5.wp),
              child: Text(
                eventInfo.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 1.hp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.wp),
              child: Text(
                eventInfo.description ??
                    "No description available for this event.",
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
          ],
        ),
      );
    });
  }
}

Widget _buildTags({required String label}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: AppColors.buttonGradient,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.gradientDarkStart,
          fontWeight: FontWeight.bold,
          fontSize: 8.sp,
        ),
      ),
    ),
  );
}
