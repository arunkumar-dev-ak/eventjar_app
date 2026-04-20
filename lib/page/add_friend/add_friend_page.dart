import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/controller/add_friend/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/dropdown/single_selected_paginated_dropdown.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_element.dart';
import 'package:eventjar/global/widget/form_submit_button.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendPage extends GetView<AddFriendController> {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),

      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        backgroundColor: AppColors.cardBg(context),
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        elevation: 4,
        centerTitle: false,
      ),

      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How would you like to add a friend?",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),

                SizedBox(height: 1.5.hp),

                SingleSelectFilterDropdown<AddFriendType>(
                  title: "Select Method",

                  items: AddFriendType.values,

                  selectedItem: controller.state.selectedType,

                  getDefaultItem: () => AddFriendType.contact,

                  getDisplayValue: (type) {
                    switch (type) {
                      case AddFriendType.contact:
                        return "From My Contacts";
                      case AddFriendType.email:
                        return "Invite by Email";
                      case AddFriendType.phone:
                        return "Invite by Phone";
                    }
                  },

                  getKeyValue: (type) => type,

                  onSelected: (type) {
                    controller.changeType(type);
                  },

                  hintText: "Choose how to add friend",

                  /// 🔥 Optional theming (nice touch)
                  headerColor: AppColors.gradientDarkStart,
                  themeColor: AppColors.gradientDarkStart,

                  selectedShade1: Colors.grey.withValues(alpha: 0.15),
                  selectedShade2: Colors.grey.withValues(alpha: 0.25),
                  selectedShade3: Colors.grey.withValues(alpha: 0.4),

                  selectedDisplayColor: AppColors.textSecondary(context),
                ),

                SizedBox(height: 2.hp),

                // DYNAMIC FORM
                Obx(() {
                  switch (controller.state.selectedType.value ??
                      AddFriendType.contact) {
                    case AddFriendType.contact:
                      return _contactView();
                    case AddFriendType.email:
                      return _emailView();
                    case AddFriendType.phone:
                      return _phoneView();
                  }
                }),

                SizedBox(height: 3.hp),

                // SUBMIT BUTTON
                SafeArea(
                  child: Row(
                    children: [
                      /// 🔥 CLEAR
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;

                          return FormButton(
                            text: "Clear",
                            isLoading: isLoading,
                            type: FormButtonType.outline,
                            onPressed: () {},
                          );
                        }),
                      ),

                      SizedBox(width: 3.wp),

                      /// 🔥 SUBMIT
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;

                          return FormButton(
                            text: isLoading ? "Sending..." : "Send Invitation",
                            isLoading: isLoading,
                            type: FormButtonType.primary,
                            icon: Icons.person_add,
                            onPressed: () {
                              if (isLoading) return;

                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                Get.focusScope?.unfocus();
                                // controller.submitForm(context);
                              }
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CONTACT VIEW
  Widget _contactView() {
    return SingleSelectPaginatedFilterDropdown<MobileContact>(
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
      onSelected: (item) {},
      hintText: "Choose a qualified contact",
      onChanged: controller.onSearchChanged,
      onRefresh: controller.onRefreshClicked,
      onClickedLoadMore: controller.onLoadMoreClicked,
      onLoadMoreLoading: controller.state.isContactDropdownLoadMoreLoading,
      onDropdownListLoading: controller.state.isContactDropdownLoading,
    );
  }

  // EMAIL VIEW
  Widget _emailView() {
    return Column(
      children: [
        FormElement(
          controller: controller.emailController,
          label: "Email",
          keyboardType: TextInputType.emailAddress,
          validator: (val) =>
              val == null || !val.contains("@") ? "Enter valid email" : null,
        ),
        SizedBox(height: 2.hp),
        FormElement(controller: controller.nameController, label: "Name"),
      ],
    );
  }

  // PHONE VIEW
  Widget _phoneView() {
    return Column(
      children: [
        FormElement(
          controller: controller.phoneController,
          label: "Phone Number *",
          keyboardType: TextInputType.phone,
          validator: (val) =>
              val == null || val.length < 10 ? "Invalid phone" : null,
        ),
        SizedBox(height: 2.hp),
        FormElement(controller: controller.nameController, label: "Name"),
      ],
    );
  }
}
