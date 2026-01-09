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
import 'package:eventjar/page/event_info/widget/event_info_book_now_button.dart';
import 'package:eventjar/page/event_info/widget/event_info_header.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eventjar/controller/event_info/extension/event_info_extension.dart';

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
              child: EventInfoBookButton(
                isFree: !(controller.state.eventInfo.value?.isPaid ?? false),
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
        final tabController = controller.tabControllerRx.value;

        if (isLoading || tabController == null) {
          return EventInfoTabBarShimmer();
        }

        final canShowAttendees = controller.canShowAttendeesTab;

        final tabNames = [
          "Overview",
          "Agenda",
          "Location",
          "Organizer",
          "Reviews",
          if (canShowAttendees) "Attendees",
        ];

        final tabIcons = [
          Icons.info_outline_rounded,
          Icons.event_note_rounded,
          Icons.location_on_outlined,
          Icons.person_outline_rounded,
          Icons.star_outline_rounded,
          if (canShowAttendees) Icons.people_outline_rounded,
        ];

        return AnimatedBuilder(
          animation: tabController,
          builder: (context, child) {
            return TabBar(
              controller: tabController,
              tabs: List.generate(tabNames.length, (i) {
                final isSelected = tabController.index == i;

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
      final tabController = controller.tabControllerRx.value;

      if (isLoading || tabController == null) {
        return EventInfoTabContentShimmer();
      }

      return Container(
        color: Colors.grey.shade50,
        child: AnimatedBuilder(
          animation: tabController,
          builder: (context, child) {
            // Show content based on selected tab index
            switch (tabController.index) {
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
