import 'package:eventjar/controller/profile_form/summary/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/profile_form/summary_form/widget/summary_dropdown.dart';
import 'package:eventjar/page/profile_form/summary_form/widget/summary_form_element.dart';
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
        child: SizedBox(
          width: 100.wp,
          height: MediaQuery.of(context).size.height,
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
                      'Short Bio / Business Pitch',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    'This will be visible in attendee lists and matchmaking cards',
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: Colors.grey.shade600,
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
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 1.hp),
                      SummaryFormElement(
                        controller: controller.availabilitySlotsController,
                        label: 'Availability',
                        hintText: 'e.g., Weekdays 9AM-5PM, Flexible',
                        validator: (val) => null,
                      ),
                    ],
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
      ),
    );
  }
}
