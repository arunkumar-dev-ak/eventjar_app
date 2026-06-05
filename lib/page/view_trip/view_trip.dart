import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/page/view_trip/friends/add_member.dart';
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

      // ---------------- APP BAR ----------------
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
        title: Text(
          controller.state.trip.value?.name ?? "",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        centerTitle: false,
      ),

      // ---------------- FLOATING BUTTON ----------------
      floatingActionButton: Obx(() {
        final isExpenseTab = controller.state.selectedTab.value == 0;

        // 1. Get the current logged-in user
        final currentUserId = UserStore.to.profile['id'];

        final creatorId = controller.state.trip.value?.createdById;

        final isCreator = currentUserId == creatorId;

        if (!isExpenseTab && !isCreator) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () {
            HapticHelper.light();

            if (isExpenseTab) {
              // Everyone can add an expense
              controller.navigateToCreateExpense();
            } else {
              // Only the creator can reach this block
              controller.getDropdownFriendList();
              showAddMemberPopup(context);
            }
          },
          backgroundColor: AppColors.gradientDarkStart,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            isExpenseTab ? "expense".tr : "member".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }),
      // ---------------- BODY ----------------
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
        child: Column(
          children: [
            SizedBox(height: 1.hp),

            // Tabs
            ViewTripTabs(),

            SizedBox(height: 1.hp),

            // PageView
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageSwiped,
                children: [
                  // ================= EXPENSE TAB =================
                  RefreshIndicator(
                    onRefresh: controller.refreshTripExpenses,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        ViewTripAnalytics(showSettleUp: true),
                        SizedBox(height: 2.hp),
                        const ExpenseList(),
                      ],
                    ),
                  ),

                  // ================= FRIEND TAB =================
                  RefreshIndicator(
                    onRefresh: controller.refreshTripFriends,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const ViewTripAnalytics(),
                        SizedBox(height: 2.hp),
                        const FriendsList(),
                      ],
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
