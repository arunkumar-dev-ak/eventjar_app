import 'dart:ui';

import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_Page.dart';
import 'package:eventjar/page/my_ticket/my_ticket_empty_page.dart';
import 'package:eventjar/page/my_ticket/widget/my_ticket_shimmer.dart';
import 'package:eventjar/page/my_ticket/widget/my_ticket_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyTicketPage extends GetView<MyTicketController> {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            Column(
              children: [
                /*----- Tabs -----*/
                const MyTicketTabs(),

                Expanded(
                  child: Obx(() {
                    //shimmer loading when empty
                    if (controller.state.isLoading.value &&
                        controller.state.tickets.isEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.all(4.wp),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return myTicketShimmer();
                        },
                      );
                    }

                    //empty state
                    if (controller.state.tickets.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: controller.refreshTickets,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 60.hp,
                            child: buildEmptyState(),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshTickets,
                      child: ListView.builder(
                        controller: controller.state.selectedTab.value == 0
                            ? controller.upcomingScrollController
                            : controller.completedScrollController,
                        key: ValueKey(controller.state.selectedTab.value),
                        padding: EdgeInsets.all(4.wp),
                        itemCount: controller.state.tickets.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.state.tickets.length) {
                            final ticket = controller.state.tickets[index];
                            return myTicketBuildTicketCard(
                              ticket,
                              context,
                              onNavigate: () =>
                                  controller.navigateToEventInfo(ticket.id),
                            );
                          }

                          if (controller
                                  .state
                                  .pagination
                                  .value
                                  ?.paging
                                  .links
                                  .next !=
                              null) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.hp),
                              child: Center(child: myTicketShimmer()),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
            /*----- Search bar processing -----*/
            Obx(() {
              if (controller.state.isLoading.value &&
                  controller.state.tickets.isNotEmpty) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(() {
        final isSearching = controller.state.showFilters.value;
        return AppBar(
          title: isSearching
              ? TextField(
                  controller: controller.searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search tickets...',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  onChanged: controller.onSearch,
                )
              : Text(
                  'My Tickets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appBarGradient),
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            _buildActionButton(
              icon: isSearching ? Icons.close : Icons.search,
              onPressed: () {
                if (isSearching) {
                  controller.searchController.clear();
                  controller.state.searchQuery.value = '';
                }
                controller.toggleFilters();
              },
            ),
            SizedBox(width: 2.wp),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildActionButton(
                  icon: Icons.date_range,
                  onPressed: () {
                    Get.focusScope?.unfocus();
                    controller.pickDateRange();
                  },
                ),
                if (controller.state.selectedDateRange.value != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: const Text(
                        'i',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 3.wp),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}
