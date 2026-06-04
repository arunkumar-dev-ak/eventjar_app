import 'package:eventjar/controller/profile_form/summary/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/profile_form/summary_form/widget/summary_dropdown.dart';
import 'package:eventjar/page/profile_form/summary_form/widget/summary_form_element.dart';
import 'package:eventjar/page/profile_form/summary_form/widget/summary_tag_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SummaryFormPage extends GetView<SummaryFormController> {
  const SummaryFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 10.sp;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Get.focusScope?.unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.hp),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Short Bio / Business Pitch
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.hp),
                    child: Text(
                      'short_bio_or_pitch'.tr,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  Text(
                    'This will be visible in attendee lists and matchmaking cards',
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: 1.5.hp),
                  SummaryFormElement(
                    controller: controller.shortBioController,
                    label: '',
                    maxLines: 4,
                    minLines: 4,
                    maxLength: 300,
                    inputFormatters: [LengthLimitingTextInputFormatter(300)],
                    validator: (val) => null,
                  ),
                  SizedBox(height: 4.hp),

                  // Years in Business
                  ExperienceDropdown(),
                  SizedBox(height: 3.hp),

                  // Availability Slots
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Availability for 1-on-1 Meetings',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      SizedBox(height: 1.hp),
                      SummaryFormElement(
                        controller: controller.availabilitySlotsController,
                        label: 'availability'.tr,
                        hintText: 'e.g., Weekdays 9AM-5PM, Flexible',
                        validator: (val) => null,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.hp),

                  // Known Languages
                  SummaryTagInput(
                    title: 'known_languages'.tr,
                    subtitle: 'add_languages_desc'.tr,
                    hintText: 'e.g., English, Hindi, Tamil',
                    items: controller.state.selectedKnownLanguages,
                  ),
                  SizedBox(height: 4.hp),

                  // Skills
                  SummaryTagInput(
                    title: 'skills'.tr,
                    subtitle: 'Add your key skills and expertise',
                    hintText: 'e.g., Leadership, Marketing',
                    items: controller.state.selectedSkills,
                  ),
                  SizedBox(height: 5.hp),

                  // Buttons
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
                            backgroundColor: AppColors.cardBg(context),
                            foregroundColor: Colors.blue.shade700,
                            elevation: 0,
                          ),
                          child: Text(
                            'reset'.tr,
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
                                    controller.submitForm(context);
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
                                    'update_info'.tr,
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
      ),
    );
  }
}
