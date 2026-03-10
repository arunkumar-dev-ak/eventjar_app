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
                decoration: InputDecoration(
                  hintText: 'Search events',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: controller.state.searchQuery.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                              controller.state.searchQuery.value = '';
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1.5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black54,
                              ),
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
              controller.pickDateRange();
            },
            child: Container(
              padding: EdgeInsets.all(2.wp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.calendar_today),
                  Obx(() {
                    if (controller.state.selectedDateRange.value != null) {
                      return Positioned(
                        right: -2,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
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
