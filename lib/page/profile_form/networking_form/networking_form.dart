import 'package:eventjar/controller/profile_form/networking/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/profile_form/networking_form/widget/connection_types_dropdown.dart';
import 'package:eventjar/page/profile_form/networking_form/widget/networking_goal_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkingFormPage extends GetView<NetworkingFormController> {
  const NetworkingFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 9.5.sp;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.hp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkingGoalDropdown(),
                SizedBox(height: 4.hp),
                // 2. Multi-select 1
                CommonMultiSelectDropdown(
                  title: "Interested in connecting with",
                  subtitle: "Select all that apply",
                  selectedItems: controller.state.selectedConnectionTypes,
                  allItems: controller.connectionTypes,
                  fieldKey: 'interestedInConnecting',
                ),
                SizedBox(height: 4.hp),

                // 3. Multi-select 2
                CommonMultiSelectDropdown(
                  title: "How can you help others?",
                  subtitle: "Select services or expertise you can offer",
                  selectedItems: controller.state.selectedHelpOfferings,
                  allItems: controller.helpOfferings,
                  fieldKey: 'helpOfferings',
                ),
                SizedBox(height: 4.hp),

                // 4. Multi-select 3
                CommonMultiSelectDropdown(
                  title: "Topics you're open to discussing",
                  subtitle: "Select relevant business topics",
                  selectedItems: controller.state.selectedDiscussionTopics,
                  allItems: controller.discussionTopics,
                  fieldKey: 'discussionTopics',
                ),

                SizedBox(height: 2.hp),

                // Buttons (same as before)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.clearForm,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.wp,
                            vertical: 1.8.hp,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: Colors.blue.shade700,
                            width: 2,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade700,
                          elevation: 0,
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Obx(() {
                        final isLoading = controller.state.isLoading.value;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Get.focusScope?.unfocus();
                                  controller.submitForm(
                                    context,
                                  ); // Pass context
                                },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.wp,
                              vertical: 1.8.hp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.blue.shade700.withValues(
                              alpha: 0.5,
                            ),
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: defaultFontSize,
                                  width: defaultFontSize,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Update Info',
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
