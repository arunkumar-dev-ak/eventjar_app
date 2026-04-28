import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/view_trip/friends/friend_list.dart';
import 'package:eventjar/page/view_trip/widget/analytics_view_trip.dart';
import 'package:eventjar/page/view_trip/expense/expense_list.dart';
import 'package:eventjar/page/view_trip/expense/expense_selected_widget.dart';
import 'package:eventjar/page/view_trip/widget/tab_view_trip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewTripPage extends GetView<ViewTripController> {
  const ViewTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.budgetScaffoldBgColor,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Goa Trip 2024",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        centerTitle: false,
        actions: [
          Obx(() {
            final isExpenseTab = controller.state.selectedTab.value == 0;

            return Row(
              children: [
                /// ➕ ADD BUTTON
                InkWell(
                  onTap: () {
                    if (isExpenseTab) {
                      controller.navigateToCreateExpense();
                    } else {
                      controller.navigateToAddFriend();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.wp),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.wp,
                      vertical: 0.6.hp,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 16),

                        SizedBox(width: 1.wp),

                        Text(
                          isExpenseTab ? "Expense" : "Friend",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
        child: Column(
          children: [
            SizedBox(height: 1.hp),

            // TABS
            ViewTripTabs(),

            ExpenseSelectedWidget(),

            SizedBox(height: 1.hp),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ViewTripAnalytics(),
                    SizedBox(height: 2.hp),

                    // LIST
                    Obx(() {
                      return controller.state.selectedTab.value == 0
                          ? ExpenseList()
                          : FriendsList();
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
