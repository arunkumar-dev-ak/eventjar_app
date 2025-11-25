import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionAttendeesTab extends StatelessWidget {
  ConnectionAttendeesTab({super.key});

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Request",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.sp),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _buildJoinedTabButton(
                  label: "Sent",
                  selected: controller.state.selectedAttendeeTab.value == 0,
                  onTap: () => controller.selectRequestTab(0),
                  leftSide: true,
                  selectedBgColor: Colors.blue,
                  unselectedBgColor: Colors.white,
                  selectedTextColor: Colors.white,
                  unselectedTextColor: Colors.blue,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.grey.shade300,
                  count: 10,
                  countGradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                  ),
                ),
                _buildJoinedTabButton(
                  label: "Received",
                  selected: controller.state.selectedAttendeeTab.value == 1,
                  onTap: () => controller.selectRequestTab(1),
                  leftSide: false,
                  selectedBgColor: Colors.green,
                  unselectedBgColor: Colors.white,
                  selectedTextColor: Colors.white,
                  unselectedTextColor: Colors.green,
                  selectedBorderColor: Colors.green,
                  unselectedBorderColor: Colors.grey.shade300,
                  count: 20,
                  countGradient: LinearGradient(
                    colors: [Colors.green, Colors.lightGreenAccent],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedTabButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool leftSide,
    int? count,
    Color? selectedBgColor,
    Color? unselectedBgColor,
    Color? selectedTextColor,
    Color? unselectedTextColor,
    Color? selectedBorderColor,
    Color? unselectedBorderColor,
    Gradient? countGradient,
    Color? countTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
        decoration: BoxDecoration(
          color: selected
              ? (selectedBgColor ?? Colors.blueAccent)
              : (unselectedBgColor ?? Colors.transparent),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(leftSide ? 5.wp : 0),
            right: Radius.circular(leftSide ? 0 : 5.wp),
          ),
          border: Border.all(
            color: selected
                ? (selectedBorderColor ?? Colors.blueAccent)
                : (unselectedBorderColor ?? Colors.blueAccent),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? (selectedTextColor ?? Colors.white)
                    : (unselectedTextColor ?? Colors.blueAccent),
                fontWeight: FontWeight.bold,
                fontSize: 7.sp,
              ),
            ),
            if (count != null)
              Container(
                margin: EdgeInsets.only(left: 6),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient:
                      countGradient ??
                      LinearGradient(
                        colors: [Colors.indigo, Colors.lightBlueAccent],
                      ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: countTextColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 7.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
