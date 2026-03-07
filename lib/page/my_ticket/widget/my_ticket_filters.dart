import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketSearchBar extends GetView<MyTicketController> {
  const MyTicketSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search events',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() {
            return controller.state.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.onSearch('');
                    },
                  )
                : const SizedBox();
          }),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: controller.onSearch,
      ),
    );
  }
}
