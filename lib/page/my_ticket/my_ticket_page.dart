import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_Page.dart';
import 'package:eventjar/page/my_ticket/my_ticket_empty_page.dart';
import 'package:eventjar/page/my_ticket/widget/my_ticket_shimmer.dart';
import 'package:eventjar/page/my_ticket/widget/my_ticket_filters.dart';
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
        appBar: AppBar(
          title: Text(
            "My Tickets",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appBarGradient),
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                /*----- Tabs -----*/
                const MyTicketTabs(),

                /*----- Search Bar -----*/
                Obx(() {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: controller.state.showFilters.value
                        ? const MyTicketFilters()
                        : const SizedBox(),
                  );
                }),

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
                        controller: controller.scrollController,
                        padding: EdgeInsets.all(4.wp),
                        itemCount: controller.state.tickets.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.state.tickets.length) {
                            final ticket = controller.state.tickets[index];
                            return myTicketBuildTicketCard(ticket, context);
                          }

                          if (controller.hasNext &&
                              controller.state.isLoadingMore.value) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.hp),
                              child: Center(
                                child: ListView.builder(
                                  padding: EdgeInsets.all(4.wp),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return myTicketShimmer();
                                  },
                                ),
                              ),
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
}
