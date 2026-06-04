import 'package:eventjar/controller/create_expense/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/multi_select_paginated_dropdown.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/dropdown/single_selected_paginated_dropdown.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_submit_button.dart';
import 'package:eventjar/model/budget_track/drop_down_response_model.dart';
import 'package:eventjar/page/add_contact/add_contact_form_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateExpensePage extends GetView<CreateExpenseController> {
  const CreateExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        elevation: 4,
        backgroundColor: AppColors.cardBg(context),
      ),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // TITLE
                ContactFormElement(
                  controller: controller.titleController,
                  label: "Expense Title *",
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                SizedBox(height: 2.hp),

                // AMOUNT
                ContactFormElement(
                  controller: controller.amountController,
                  label: "Amount *",
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter amount" : null,
                ),
                SizedBox(height: 2.hp),

                // CATEGORY DROPDOWN
                SingleSelectFilterDropdown<String>(
                  title: "Trip Category",
                  items: controller.state.categories,
                  selectedItem: controller.state.selectedCategory,
                  getDefaultItem: () => 'shopping'.tr,
                  getDisplayValue: (item) => item,
                  getKeyValue: (item) => item,
                  onSelected: (val) =>
                      controller.state.selectedCategory.value = val,
                  hintText: 'select_category'.tr,
                  headerColor: AppColors.gradientDarkStart,
                  themeColor: AppColors.gradientDarkStart,
                  selectedShade1: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.15),
                  selectedShade2: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.25),
                  selectedShade3: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.4),
                  selectedDisplayColor: AppColors.textPrimary(context),
                  dropdownIcon: Icons.keyboard_arrow_down_rounded,
                ),
                SizedBox(height: 2.hp),

                // PAID BY (Single Select)
                SingleSelectPaginatedFilterDropdown<DropdownMemberModel>(
                  title: "Paid By",
                  items: controller.state.members,
                  selectedItem: controller.state.paidBy,
                  getDefaultItem: () => controller.state.members.first,
                  getDisplayValue: (item) => item.displayName,
                  getKeyValue: (item) => item,

                  onSelected: (val) => controller.state.paidBy.value = val,
                  hintText: 'select_payer'.tr,
                  onChanged: controller.onSearchMembers,
                  onRefresh: controller.onRefreshMembers,
                  onClickedLoadMore: controller.onLoadMoreMembers,
                  onDropdownListLoading: controller.state.isMembersLoading,
                  onLoadMoreLoading: controller.state.isMembersLoadMoreLoading,
                  headerColor: AppColors.gradientDarkStart,
                  themeColor: AppColors.gradientDarkStart,
                  selectedShade1: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.15),
                  selectedShade2: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.25),
                  selectedShade3: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.4),
                ),
                SizedBox(height: 2.hp),

                // SPLIT WITH (Multi Select)
                MultiSelectPaginatedDropdown<dynamic>(
                  // Assuming dynamic is TripFriendModel
                  title: 'split_with'.tr,
                  items: controller.state.members,
                  selectedItemsMap: controller.state.selectedMembers,
                  getDisplayValue: (item) => item.displayName,
                  getKeyValue: (item) => item.memberId,
                  onChanged: controller.onSearchMembers,
                  onLoadMore: controller.onLoadMoreMembers,
                  onRefresh: controller.onRefreshMembers,
                  isLoading: controller.state.isMembersLoading,
                  isLoadMoreLoading: controller.state.isMembersLoadMoreLoading,
                  hintText: 'select_members'.tr,
                  selectedShade1: (isDark ? Colors.white : Colors.grey)
                      .withValues(alpha: 0.15),
                  selectedDisplayColor: AppColors.textPrimary(context),
                ),
                SizedBox(height: 0.5.hp),

                // ADD NEW MEMBER BUTTON
                InkWell(
                  onTap: () {
                    HapticHelper.light();
                    controller.navigateToAddFriend();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.wp,
                      horizontal: 1.wp,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: AppColors.textSecondary(context),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Click To Add New Member",
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.hp),

                // DESCRIPTION
                ContactFormElement(
                  controller: controller.descriptionController,
                  label: 'description'.tr,
                  maxLines: 3,
                ),
                SizedBox(height: 3.hp),

                // BUTTONS
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;
                          return FormButton(
                            text: 'clear'.tr,
                            isLoading: false,
                            type: FormButtonType.outline,
                            onPressed: () {
                              if (!isLoading) controller.clearForm();
                            },
                          );
                        }),
                      ),
                      SizedBox(width: 3.wp),

                      // SUBMIT
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;
                          return FormButton(
                            text: isLoading ? "Creating..." : 'create_expense'.tr,
                            isLoading: isLoading,
                            type: FormButtonType.primary,
                            icon: Icons.receipt_long,
                            onPressed: () {
                              if (isLoading) return;
                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                Get.focusScope?.unfocus();
                                controller.submit();
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
}
