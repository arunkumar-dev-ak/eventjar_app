import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/view_trip/friends/friend_list.dart';
import 'package:eventjar/page/view_trip/widget/analytics_view_trip.dart';
import 'package:eventjar/page/view_trip/expense/expense_list.dart';
import 'package:eventjar/page/view_trip/widget/tab_view_trip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewTripPage extends GetView<ViewTripController> {
  const ViewTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.budgetScaffoldBgColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            HapticHelper.light();
            Navigator.pop(context);
          },
        ),
        title: Obx(() {
          final tripName = controller.state.trip.value?.name ?? "";
          final tabLabel =
              controller.state.selectedTab.value == 0 ? "Expense" : "Friends";
          return Text(
            tripName.isNotEmpty ? "$tripName - $tabLabel" : tabLabel,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        centerTitle: false,
      ),

      floatingActionButton: Obx(() {
        final isExpenseTab = controller.state.selectedTab.value == 0;
        return FloatingActionButton.extended(
          onPressed: () {
            HapticHelper.light();
            if (isExpenseTab) {
              controller.navigateToCreateExpense();
            } else {
              controller.navigateToAddFriend();
            }
          },
          backgroundColor: AppColors.gradientDarkStart,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            isExpenseTab ? "Expense" : "Friend",
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
        child: Column(
          children: [
            SizedBox(height: 1.hp),

            ViewTripTabs(),

            SizedBox(height: 1.hp),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageSwiped,
                children: [
                  RefreshIndicator(
                    onRefresh: controller.refreshTripExpenses,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ViewTripAnalytics(showSettleUp: true),
                          SizedBox(height: 2.hp),
                          ExpenseList(),
                        ],
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: controller.refreshTripFriends,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ViewTripAnalytics(),
                          SizedBox(height: 2.hp),
                          FriendsList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
