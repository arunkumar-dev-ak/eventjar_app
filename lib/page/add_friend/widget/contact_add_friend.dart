import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/single_selected_paginated_dropdown.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/add_friend/widget/new_add_friend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactAddFriendContactView extends GetView<AddFriendController> {
  const ContactAddFriendContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CONTACT DROPDOWN (TOP)
        SingleSelectPaginatedFilterDropdown<MobileContact>(
          title: 'Select contact',
          items: controller.state.contacts,
          selectedItem: controller.state.selectedContact,
          getDefaultItem: () => controller.state.contacts.first,
          getDisplayValue: (item) => "${item.name} - ${item.email}",
          getKeyValue: (item) => item,
          onSelected: (item) {
            controller.onContactSelected(item);
          },
          hintText: 'Choose contact',
          onChanged: controller.onSearchChanged,
          onRefresh: controller.onRefreshClicked,
          onClickedLoadMore: controller.onLoadMoreClicked,
          onLoadMoreLoading: controller.state.isContactDropdownLoadMoreLoading,
          onDropdownListLoading: controller.state.isContactDropdownLoading,
          hasMore: controller.state.hasMoreContacts,
          headerColor: AppColors.gradientDarkStart,
          themeColor: AppColors.gradientDarkStart,
          selectedShade1:
              (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey)
                  .withValues(alpha: 0.15),
          selectedShade2:
              (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey)
                  .withValues(alpha: 0.25),
          selectedShade3:
              (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey)
                  .withValues(alpha: 0.4),
          selectedDisplayColor: AppColors.textPrimary(context),
          dropdownIcon: Icons.keyboard_arrow_down_rounded,
        ),
        SizedBox(height: 2.hp),

        NewAddFriend(),
      ],
    );
  }
}
