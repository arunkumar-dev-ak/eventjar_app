import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoConnectionSearchBar extends StatelessWidget {
  EventInfoConnectionSearchBar({super.key});

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.blueAccent, width: 1.5),
      ),
      width: double.infinity,
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: "Search by Name or Company",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Obx(
            () => controller.state.searchText.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.state.searchText.value = "";
                    },
                  )
                : SizedBox.shrink(),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        ),
        style: TextStyle(fontSize: 14, color: AppColors.textPrimary(context)),
        onChanged: (val) => {controller.state.searchText.value = val},
      ),
    );
  }
}
