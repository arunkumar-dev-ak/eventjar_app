import 'package:eventjar_app/controller/my_ticket/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/page/my_ticket/my_ticket_card_Page.dart';
import 'package:eventjar_app/page/my_ticket/my_ticket_empty_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketPage extends GetView<MyTicketController> {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "My Tickets",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        // Loading state
        if (controller.state.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Empty state
        if (controller.state.tickets.isEmpty) {
          return buildEmptyState();
        }

        // Tickets list
        return RefreshIndicator(
          onRefresh: controller.refreshTickets,
          child: ListView.builder(
            padding: EdgeInsets.all(4.wp),
            itemCount: controller.state.tickets.length + 1,
            itemBuilder: (context, index) {
              // Show loading indicator at bottom when loading more
              if (index == controller.state.tickets.length) {
                if (controller.state.isLoadingMore.value) {
                  return Padding(
                    padding: EdgeInsets.all(4.wp),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Load more when reaching end
                if (controller.state.pagination.value?.hasNextPage ?? false) {
                  controller.loadMoreTickets();
                }

                return SizedBox.shrink();
              }

              final ticket = controller.state.tickets[index];
              return myTicketBuildTicketCard(ticket, context);
            },
          ),
        );
      }),
    );
  }
}
