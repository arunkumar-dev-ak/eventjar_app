import 'package:eventjar/controller/create_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_element.dart';
import 'package:eventjar/global/widget/form_submit_button.dart';
import 'package:eventjar/global/dropdown/multi_select_paginated_dropdown.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/page/profile_form/summary_form/widget/summary_form_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTripPage extends GetView<CreateTripController> {
  const CreateTripPage({super.key});

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
      ),

      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                /// Trip Name
                FormElement(
                  controller: controller.tripNameController,
                  label: "Trip Name *",
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),

                SizedBox(height: 2.hp),

                /// Destination
                FormElement(
                  controller: controller.destinationController,
                  label: "Destination *",
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),

                SizedBox(height: 2.hp),

                /// Budget
                FormElement(
                  controller: controller.budgetController,
                  label: "Budget (Optional)",
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 2.hp),

                /// Invite Friends (Multi Select)
                MultiSelectPaginatedDropdown<MobileContact>(
                  title: "Invite Friends",
                  items: controller.state.contacts,
                  selectedItemsMap: controller.state.selectedFriendsMap,
                  getDisplayValue: (item) => item.name,
                  getKeyValue: (item) => item.id,
                  onChanged: controller.onSearchChanged,
                  onLoadMore: controller.onLoadMoreClicked,
                  onRefresh: controller.onRefreshClicked,
                  isLoading: controller.state.isDropdownLoading,
                  isLoadMoreLoading: controller.state.isDropdownLoadMoreLoading,
                ),

                SizedBox(height: 2.hp),

                /// Description
                SummaryFormElement(
                  controller: controller.descriptionController,
                  label: "Description",
                  hintText: "Write about your trip...",
                  maxLines: 4,
                  minLines: 3,
                  maxLength: 200,
                ),

                SizedBox(height: 3.hp),

                /// Buttons
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;

                          return FormButton(
                            text: "Clear",
                            isLoading: isLoading,
                            type: FormButtonType.outline,
                            onPressed: controller.clearForm,
                          );
                        }),
                      ),

                      SizedBox(width: 3.wp),

                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;

                          return FormButton(
                            text: isLoading ? "Creating..." : "Create Trip",
                            isLoading: isLoading,
                            type: FormButtonType.primary,
                            icon: Icons.flight_takeoff,
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
