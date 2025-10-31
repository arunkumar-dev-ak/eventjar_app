import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/global/widget/gradient_text.dart';
import 'package:eventjar_app/page/event_info/tabs/agenda/agenda_page.dart';
import 'package:eventjar_app/page/event_info/tabs/images/image_page.dart';
import 'package:eventjar_app/page/event_info/tabs/location/location_page.dart';
import 'package:eventjar_app/page/event_info/tabs/organizer/organizer_page.dart';
import 'package:eventjar_app/page/event_info/tabs/overview/overview_page.dart';
import 'package:eventjar_app/page/event_info/tabs/reviews/review_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoContent extends StatelessWidget {
  final EventInfoController controller = Get.find();

  EventInfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100.wp,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: controller.tabController,
              builder: (context, child) {
                return TabBar(
                  controller: controller.tabController,
                  tabs: List.generate(6, (i) {
                    final tabNames = [
                      "Overview",
                      "Agenda",
                      "Location",
                      "Organizer",
                      "Reviews",
                      "Images",
                    ];

                    final isSelected = controller.tabController.index == i;

                    final childText = Text(
                      tabNames[i],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    );

                    return Tab(
                      child: isSelected
                          ? GradientText(
                              textSize: 10.sp,
                              content: tabNames[i],
                              gradientStart: AppColors.gradientDarkStart,
                              gradientEnd: AppColors.gradientDarkEnd,
                              fontWeight: FontWeight.bold,
                            )
                          : childText,
                    );
                  }),
                  isScrollable: true,
                  dividerColor: Colors.grey,
                  indicatorColor: AppColors.gradientDarkStart,
                  tabAlignment: TabAlignment.start,
                );
              },
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: <Widget>[
                  OverViewPage(),
                  AgendaPage(),
                  LocationPage(),
                  OrganizerPage(),
                  ReviewsPage(),
                  ImagesPage(),
                ],
              ),
            ),
            eventInfoBookButton(isFree: true),
          ],
        ),
      ),
    );
  }
}

Widget eventInfoBookButton({required bool isFree}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 1.hp),
    child: Container(
      padding: EdgeInsets.all(3.wp),
      width: 100.wp,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Book now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isFree) ...[freeButtonLabel()],
        ],
      ),
    ),
  );
}

Widget freeButtonLabel() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 1.wp, horizontal: 2.wp),

    decoration: BoxDecoration(
      gradient: AppColors.appBarGradient,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      "free",
      style: TextStyle(
        color: Colors.white,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
