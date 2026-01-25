import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/scheduler/widget/schedule_form_element.dart';
import 'package:eventjar/page/scheduler/widget/scheduler_contact_dropdown.dart';
import 'package:eventjar/page/scheduler/widget/scheduler_duration_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulerPage extends GetView<SchedulerController> {
  const SchedulerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // ✅ Qualified Contact Dropdown (Global dropdown)
                SchedulerContactDropdown(),
                SizedBox(height: 2.hp),

                ScheduleFormElement(
                  controller: controller.state.dateTimeController,
                  label: 'Date & Time *',
                  readOnly: true,
                  onTap: () => controller.pickDateTime(context),
                  validator: controller.validateDate,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue.shade700,
                  ),
                ),

                SizedBox(height: 2.hp),

                SchedulerDurationDropdown(),
                SizedBox(height: 2.hp),

                ScheduleFormElement(
                  controller: controller.state.notesController,
                  label: 'Meeting Notes',
                  maxLines: 4,
                  minLines: 3,
                ),
                SizedBox(height: 3.hp),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => OutlinedButton(
                          onPressed: controller.state.isLoading.value
                              ? null
                              : controller.clearForm,
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
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.state.isLoading.value
                              ? null
                              : () {
                                  if (controller.formKey.currentState
                                          ?.validate() ??
                                      false) {
                                    Get.focusScope?.unfocus();
                                    controller.submitForm(context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.wp,
                              vertical: 1.8.hp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            elevation: 5,
                          ),
                          child: controller.state.isLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Schedule Meeting',
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
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
