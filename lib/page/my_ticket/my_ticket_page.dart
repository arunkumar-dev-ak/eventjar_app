import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_Page.dart';
import 'package:eventjar/page/my_ticket/my_ticket_empty_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
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
            controller: controller.scrollController,
            padding: EdgeInsets.all(4.wp),
            itemCount: controller.state.tickets.length + 1,
            itemBuilder: (context, index) {
              if (index < controller.state.tickets.length) {
                final ticket = controller.state.tickets[index];
                return myTicketBuildTicketCard(ticket, context);
              }

              // Pagination loader
              final hasNext =
                  controller.state.pagination.value?.hasNextPage ?? false;

              if (hasNext) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.gradientDarkStart,
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        );
      }),
    );
  }
}
