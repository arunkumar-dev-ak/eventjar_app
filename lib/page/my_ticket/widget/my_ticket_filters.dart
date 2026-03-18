import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketFilters extends GetView<MyTicketController> {
  const MyTicketFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
      child: Row(
        children: [
          /* Search Field */
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.searchController,
                style: TextStyle(
                  fontSize: 9.sp, // text inside input
                ),
                decoration: InputDecoration(
                  hintText: 'Search events',
                  hintStyle: TextStyle(fontSize: 9.sp),
                  isDense: true,

                  contentPadding: EdgeInsets.zero, // no padding

                  prefixIcon: Icon(Icons.search, size: 12.sp),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.wp),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.wp),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 0.3.wp,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.wp),
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                      width: 0.4.wp,
                    ),
                  ),

                  suffixIcon: controller.state.searchQuery.value.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(right: 1.wp),
                          child: GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                              controller.state.searchQuery.value = '';
                              Get.focusScope?.unfocus();
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 13.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : null,
                ),
                onChanged: controller.onSearch,
              ),
            ),
          ),

          SizedBox(width: 3.wp),

          /* Date Filter */
          GestureDetector(
            onTap: () {
              Get.focusScope?.unfocus();
              controller.pickDateRange();
            },
            child: Container(
              padding: EdgeInsets.all(1.5.wp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.wp),
                border: Border.all(color: Colors.grey.shade300, width: 0.3.wp),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14.sp,
                    color: Colors.black87,
                  ),
                  Obx(() {
                    if (controller.state.selectedDateRange.value != null) {
                      return Positioned(
                        right: -0.8.wp,
                        top: -0.8.hp,
                        child: Container(
                          padding: EdgeInsets.all(0.7.wp),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 0.6.wp,
                            ),
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
