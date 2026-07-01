import 'package:eventjar/controller/contact_list_meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/reschedule_availability_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescheduleMeetingContactList
    extends GetView<ContactListMeetingController> {
  final String meetingId;

  const RescheduleMeetingContactList({super.key, required this.meetingId});

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
              width: 90.wp,
              constraints: BoxConstraints(maxHeight: 85.hp),
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
                    SizedBox(height: 2.hp),
                    Obx(() => RescheduleAvailabilityContent(
                          availability: controller.availability,
                          selectedDuration:
                              controller.state.selectedDuration.value,
                          allowedDurations: controller.hostAllowedDurations,
                          onDurationSelected: controller.selectDuration,
                          onDateSelected: controller.onDateSelected,
                          onSlotSelected: controller.onSlotSelected,
                          formatSlotLabel: controller.formatSlotLabel,
                          isDayAvailable: controller.isDayAvailable,
                          maxBookingDate: controller.maxBookingDate,
                        )),
                    SizedBox(height: 3.hp),
                    SizedBox(
                      width: double.infinity,
                      height: 6.hp,
                      child: Obx(() {
                        final hasSlot = controller
                                .availability.selectedSlotIso.value !=
                            null;
                        return ElevatedButton(
                          onPressed: isLoading || !hasSlot
                              ? null
                              : () async {
                                  final success = await controller
                                      .rescheduleMeeting(meetingId: meetingId);
                                  if (success) {
                                    Navigator.pop(Get.context!);
                                    Navigator.pop(Get.context!, "refresh");
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            disabledBackgroundColor:
                                Colors.blueAccent.withValues(alpha: 0.4),
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
                        );
                      }),
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
