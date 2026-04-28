import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/controller/add_friend/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_submit_button.dart';
import 'package:eventjar/page/add_friend/widget/contact_add_friend.dart';
import 'package:eventjar/page/add_friend/widget/new_add_friend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendPage extends GetView<AddFriendController> {
  const AddFriendPage({super.key});

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
                      case AddFriendType.newFriend:
                        return "New Friend";
                      case AddFriendType.contact:
                        return "From My Contacts";
                    }
                  },

                  getKeyValue: (type) => type,

                  onSelected: (type) {
                    controller.changeType(type);
                  },

                  hintText: "Choose how to add friend",

                  // Optional theming (nice touch)
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

                Obx(() {
                  final type = controller.state.selectedType.value;

                  if (type == AddFriendType.contact) {
                    return const ContactAddFriendContactView();
                  } else {
                    return const NewAddFriend();
                  }
                }),

                SizedBox(height: 3.hp),

                // SUBMIT BUTTON
                SafeArea(
                  child: Row(
                    children: [
                      // CLEAR
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

                      // SUBMIT
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
}
