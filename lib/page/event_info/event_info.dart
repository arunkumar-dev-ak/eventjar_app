import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/tabs/agenda/agenda_page.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_page.dart';
import 'package:eventjar/page/event_info/tabs/location/location_page.dart';
import 'package:eventjar/page/event_info/tabs/organizer/organizer_page.dart';
import 'package:eventjar/page/event_info/tabs/overview/overview_page.dart';
import 'package:eventjar/page/event_info/tabs/reviews/review_page.dart';
import 'package:eventjar/page/event_info/widget/event_info_appbar.dart';
import 'package:eventjar/page/event_info/widget/event_info_header.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EventInfoPage extends GetView<EventInfoController> {
  const EventInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // Fixed App Bar
              EventInfoAppBar(),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (image + quick info)
                      EventInfoHeader(),
                      // Event Name
                      _buildEventName(),
                      // Tab Bar
                      _buildTabBar(),
                      // Tab Content (not scrollable, fixed height based on content)
                      _buildTabContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.only(bottom: 1.hp, top: 0.5.hp),
              height: 6.hp,
              child: eventInfoBookButton(
                isFree: !(controller.state.eventInfo.value?.isPaid ?? false),
                onTap: () {
                  controller.navigateToCheckOut();
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEventName() {
    return Obx(() {
      final isLoading = controller.state.isLoading.value;

      if (isLoading) {
        return EventInfoEventNameShimmer();
      }
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        child: Obx(() {
          final eventInfo = controller.state.eventInfo.value;
          final isLoading = controller.state.isLoading.value;

          if (isLoading) {
            return Container(
              height: 24,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }

          return Text(
            eventInfo?.title ?? 'Event Details',
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          );
        }),
      );
    });
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 1.hp),
      child: Obx(() {
        final isLoading = controller.state.isLoading.value;

        if (isLoading) {
          return EventInfoTabBarShimmer();
        }
        return AnimatedBuilder(
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
                  "Attendees",
                ];
                final tabIcons = [
                  Icons.info_outline_rounded,
                  Icons.event_note_rounded,
                  Icons.location_on_outlined,
                  Icons.person_outline_rounded,
                  Icons.star_outline_rounded,
                  Icons.people_outline_rounded,
                ];

                final isSelected = controller.tabController.index == i;

                return Tab(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 12 : 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.buttonGradient : null,
                      color: isSelected ? null : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tabIcons[i],
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Text(
                            tabNames[i],
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.symmetric(horizontal: 4.wp),
            );
          },
        );
      }),
    );
  }

  Widget _buildTabContent() {
    return Obx(() {
      final isLoading = controller.state.isLoading.value;

      if (isLoading) {
        return EventInfoTabContentShimmer();
      }

      return Container(
        color: Colors.grey.shade50,
        child: AnimatedBuilder(
          animation: controller.tabController,
          builder: (context, child) {
            // Show content based on selected tab index
            switch (controller.tabController.index) {
              case 0:
                return OverViewPage();
              case 1:
                return AgendaPage();
              case 2:
                return LocationPage();
              case 3:
                return OrganizerPage();
              case 4:
                return ReviewsPage();
              case 5:
                return EventInfoConnectionTab();
              default:
                return OverViewPage();
            }
          },
        ),
      );
    });
  }
}

Widget eventInfoBookButton({
  required bool isFree,
  required VoidCallback onTap,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5.wp),
    decoration: BoxDecoration(
      gradient: AppColors.buttonGradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.gradientDarkEnd.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.5.wp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.confirmation_num_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 3.wp),
              Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              if (isFree) ...[
                SizedBox(width: 3.wp),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    "FREE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
              SizedBox(width: 2.wp),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
