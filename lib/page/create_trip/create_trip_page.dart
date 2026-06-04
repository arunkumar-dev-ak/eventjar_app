import 'package:currency_picker/currency_picker.dart';
import 'package:eventjar/controller/create_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_element.dart';
import 'package:eventjar/global/widget/form_submit_button.dart';
import 'package:eventjar/global/dropdown/multi_select_paginated_dropdown.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
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

                /// Budget & Currency Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: FormElement(
                        controller: controller.budgetController,
                        label: 'budget_optional'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 2.wp),
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        final currency =
                            controller.state.selectedCurrency.value;
                        return GestureDetector(
                          onTap: () {
                            HapticHelper.light();
                            final selected =
                                controller.state.selectedCurrency.value;
                            final favorites = <String>[
                              selected.code,
                              if (selected.code != 'INR') 'INR',
                              if (selected.code != 'USD') 'USD',
                              if (selected.code != 'EUR') 'EUR',
                              if (selected.code != 'GBP') 'GBP',
                            ];
                            showCurrencyPicker(
                              context: context,
                              showFlag: true,
                              showSearchField: true,
                              showCurrencyName: true,
                              showCurrencyCode: true,
                              onSelect: controller.selectCurrency,
                              favorite: favorites,
                            );
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'currency'.tr,
                              labelStyle: TextStyle(fontSize: 10.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.border(context),
                                  width: 1.5,
                                ),
                              ),
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textHint(context),
                              ),
                            ),
                            child: Text(
                              '${currency.symbol}  ${currency.code}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                SizedBox(height: 2.hp),

                /// Invite Friends (Multi Select)
                MultiSelectPaginatedDropdown<SplitTrackFriend>(
                  title: 'invite_friends'.tr,
                  hintText: 'select_friends'.tr,
                  items: controller.state.friends,
                  selectedItemsMap: controller.state.selectedFriendsMap,
                  getDisplayValue: (item) => item.name,
                  getKeyValue: (item) => item.id,
                  getSubtitleValue: (item) {
                    switch (item.status) {
                      case 'pending':
                        return 'invitation_yet_to_accept'.tr;
                      case 'accepted':
                        return 'accepted'.tr;
                      case 'rejected':
                        return 'Invitation declined';
                      default:
                        return item.status;
                    }
                  },
                  getLeadingWidget: (item) {
                    final initial = item.name.isNotEmpty
                        ? item.name[0].toUpperCase()
                        : '?';
                    return CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.gradientDarkStart.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        initial,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gradientDarkStart,
                        ),
                      ),
                    );
                  },
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
                  label: 'description'.tr,
                  hintText: 'write_about_trip'.tr,
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
                            text: 'clear'.tr,
                            isLoading: false,
                            type: FormButtonType.outline,
                            onPressed: isLoading ? null : controller.clearForm,
                          );
                        }),
                      ),

                      SizedBox(width: 3.wp),

                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;

                          return FormButton(
                            text: isLoading ? "Creating..." : 'create_trip'.tr,
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
