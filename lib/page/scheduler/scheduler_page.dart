import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/scheduler/widget/schedule_contact_display.dart';
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
                Obx(() {
                  final isReschedule =
                      controller.state.selectedMeeting.value != null;
                  return isReschedule
                      ? buildContactDisplayForSchedulePage(
                          controller.state.selectedMeeting.value!,
                        )
                      : SchedulerContactDropdown();
                }),
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

                Obx(() {
                  if (controller.state.selectedMeeting.value != null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      SchedulerDurationDropdown(),
                      SizedBox(height: 2.hp),

                      ScheduleFormElement(
                        controller: controller.state.notesController,
                        label: 'Meeting Notes',
                        maxLines: 4,
                        minLines: 3,
                      ),
                      SizedBox(height: 2.hp),
                    ],
                  );
                }),

                Obx(() {
                  if (controller.state.selectedMeeting.value == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      _buildReadOnlyFieldTab(
                        label: 'Duration',
                        value: controller.state.selectedMeeting.value!.duration
                            .toString(),
                        icon: Icons.timer_outlined,
                      ),
                      SizedBox(height: 2.hp),
                      _buildReadOnlyFieldTab(
                        label: 'Status',
                        value: controller.state.selectedMeeting.value!.status,
                        icon: Icons.schedule_outlined,
                        color: _getStatusColor(
                          controller.state.selectedMeeting.value!.status,
                        ),
                      ),
                      SizedBox(height: 2.hp),
                      _buildReadOnlyFieldTab(
                        label: 'Notes',
                        value:
                            controller.state.selectedMeeting.value!.notes ??
                            'No notes added',
                        icon: Icons.notes_outlined,
                        maxLines: 3,
                      ),
                      SizedBox(height: 2.hp),
                    ],
                  );
                }),

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
                          child: Obx(
                            () => Text(
                              controller.state.selectedMeeting.value != null
                                  ? 'Reset'
                                  : 'Clear',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                              ),
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
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Obx(
                                  () => Text(
                                    controller.state.selectedMeeting.value !=
                                            null
                                        ? 'Reschedule Meeting'
                                        : 'Schedule Meeting',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
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

  // 🔥 Read-only field tabs
  Widget _buildReadOnlyFieldTab({
    required String label,
    required String value,
    required IconData icon,
    Color? color,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBgStatic,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerStatic),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStatic,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.wp),
            decoration: BoxDecoration(
              color: (color ?? AppColors.dividerStatic).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 5.wp, color: color ?? AppColors.textSecondaryStatic),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: AppColors.textSecondaryStatic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryStatic,
                    height: 1.2,
                  ),
                  maxLines: maxLines,
                  overflow: maxLines > 1 ? TextOverflow.ellipsis : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    final statusStr = status?.toUpperCase();
    switch (statusStr) {
      case 'SCHEDULED':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
