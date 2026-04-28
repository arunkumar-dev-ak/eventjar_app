import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewTripTabs extends GetView<ViewTripController> {
  const ViewTripTabs({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(0.5.wp),
        decoration: BoxDecoration(
          color: AppColors.budgetTabColor,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Row(
          children: [
            _tabItem("Expenses", controller.state.selectedTab.value == 0, 0),
            _tabItem("Friends", controller.state.selectedTab.value == 1, 1),
          ],
        ),
      );
    });
  }
}

Widget _tabItem(String title, bool selected, int index) {
  return Expanded(
    child: GestureDetector(
      onTap: () => Get.find<ViewTripController>().changeTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.hp),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: selected
                  ? AppColors.gradientDarkStart
                  : AppColors.budgetTabTextColor,
            ),
          ),
        ),
      ),
    ),
  );
}
