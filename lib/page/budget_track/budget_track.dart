import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/appbar_button.dart';
import 'package:eventjar/page/budget_track/widget/trip_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetTrackPage extends GetView<BudgetTrackController> {
  const BudgetTrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.budgetScaffoldBgColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trips",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        actions: [
          Row(
            children: [
              // FRIEND
              AppbarButton(
                icon: Icons.groups_rounded,
                onPressed: controller.navigateToFriendList,
              ),

              SizedBox(width: 3.wp),

              // TRANSACTION
              // AppbarButton(
              //   icon: Icons.receipt_long_rounded,
              //   onPressed: controller.navigateToTransaction,
              // ),

              // SizedBox(width: 3.wp),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
        child: RefreshIndicator(
          onRefresh: controller.refreshTrips,
          child: TripsList(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticHelper.medium();
          controller.navigateToCreateTrip();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
