import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/dropdown/single_selected_paginated_dropdown.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulerContactDropdown extends StatelessWidget {
  const SchedulerContactDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SchedulerController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Qualified Contact *',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SingleSelectPaginatedFilterDropdown<MobileContact>(
          title: "Select Qualified Contact",
          items: controller.state.contacts,
          selectedItem: controller.state.selectedContact,
          getDefaultItem: () => controller.state.contacts.first,
          getDisplayValue: (item) {
            return item.id.isNotEmpty
                ? "${item.name} - ${item.email}"
                : "Choose a qualified contact";
          },
          getKeyValue: (item) => item,
          onSelected: controller.selectContact,
          hintText: "Choose a qualified contact",
          onChanged: controller.onSearchChanged,
          onRefresh: controller.onRefreshClicked,
          onClickedLoadMore: controller.onLoadMoreClicked,
          onLoadMoreLoading: controller.state.isContactDropdownLoadMoreLoading,
          onDropdownListLoading: controller.state.isContactDropdownLoading,
        ),
      ],
    );
  }
}
