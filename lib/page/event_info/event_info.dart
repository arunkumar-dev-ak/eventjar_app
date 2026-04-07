import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/controller/event_info/extension/event_info_extension.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/customized_upgrader/custom_upgrade_alert.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_page.dart';
import 'package:eventjar/page/event_info/tabs/overview/overview_page.dart';
import 'package:eventjar/page/event_info/widget/event_info_appbar.dart';
import 'package:eventjar/page/event_info/widget/event_info_book_now_button.dart';
import 'package:eventjar/page/event_info/widget/event_info_header.dart';
import 'package:eventjar/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EventInfoPage extends GetView<EventInfoController> {
  const EventInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: isDark
            ? AppColors.darkBackground
            : Colors.white,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cardBg(context),
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

  Widget _buildTabBar() {
    return Container(
      color: AppColors.cardBgStatic,
      padding: EdgeInsets.only(bottom: 1.hp),
      child: Obx(() {
        final isLoading = controller.state.isLoading.value;
        final tabController = controller.tabControllerRx.value;

        if (isLoading || tabController == null) {
          return EventInfoTabBarShimmer();
        }

        final tabCount = tabController.length;
        final tabNames = ["Overview", if (tabCount > 1) "Attendees"];
        final tabIcons = [
          Icons.info_outline_rounded,
          if (tabCount > 1) Icons.people_outline_rounded,
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
                      color: isSelected ? null : AppColors.chipBg(context),
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
                              : AppColors.textSecondary(context),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tabNames[i],
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary(context),
                          ),
                        ),
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

  Widget _buildAttendeeGate(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.wp, vertical: 6.hp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.buttonGradient.createShader(bounds),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.hp),
          Text(
            "Register to Connect",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.hp),
          Text(
            "Book a ticket to access attendees and start networking.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 3.hp),
          GestureDetector(
            onTap: () => controller.handleBottomButton(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.wp, vertical: 1.5.hp),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ],
      ),
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
        color: AppColors.scaffoldBgStatic,
        child: AnimatedBuilder(
          animation: tabController,
          builder: (context, child) {
            // Show content based on selected tab index
            switch (tabController.index) {
              case 0:
                return OverViewPage();
              case 1:
                // Not logged in — listener handles redirect, show nothing briefly
                if (!controller.isLoggedIn.value) {
                  return const SizedBox.shrink();
                }
                // Logged in but not registered — show registration gate
                if (!controller.canAccessAttendeesTab) {
                  return _buildAttendeeGate(context);
                }
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
