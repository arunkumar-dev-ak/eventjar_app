import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescheduleMeetingDialog extends GetView<MeetingController> {
  final String meetingId;

  const RescheduleMeetingDialog({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.state.isRescheduling.value;

      return PopScope(
        canPop: !isLoading,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 85.wp,
              padding: EdgeInsets.all(5.wp),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "reschedule_meeting".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.hp),
                    TextField(
                      controller: controller.rescheduleDateController,
                      readOnly: true,
                      onTap: isLoading ? null : controller.pickRescheduleDate,
                      decoration: InputDecoration(
                        labelText: 'select_date'.tr,
                        filled: true,
                        fillColor: AppColors.inputBg(context),
                        suffixIcon: Icon(Icons.calendar_today, size: 15.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.hp),
                    TextField(
                      controller: controller.rescheduleTimeController,
                      readOnly: true,
                      onTap: isLoading ? null : controller.pickRescheduleTime,
                      decoration: InputDecoration(
                        labelText: 'select_time'.tr,
                        filled: true,
                        fillColor: AppColors.inputBg(context),
                        suffixIcon: Icon(Icons.access_time, size: 15.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.hp),
                    SizedBox(
                      width: double.infinity,
                      height: 6.hp,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                final success = await controller
                                    .rescheduleNetworkMeeting(
                                      meetingId: meetingId,
                                    );
                                if (success) {
                                  Navigator.pop(Get.context!);
                                  controller.fetchOneOnOneMeetings(
                                    forceRefresh: true,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 2.2.hp,
                                    width: 2.2.hp,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 3.wp),
                                  Text(
                                    "confirming".tr,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "confirm".tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
