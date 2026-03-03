import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/controller/contact_list_meeting/controller.dart';

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
        onPopInvokedWithResult: (didPop, result) {
          // if (isLoading) {
          //   AppSnackbar.warning(
          //     title: "Please wait",
          //     message: "Rescheduling in progress...",
          //   );
          // }
        },
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 85.wp,
              padding: EdgeInsets.all(5.wp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      "Reschedule Meeting",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 3.hp),

                    /// DATE FIELD
                    TextField(
                      controller: controller.meetingDateController,
                      readOnly: true,
                      onTap: isLoading ? null : controller.pickMeetingDate,
                      decoration: InputDecoration(
                        labelText: "Select Date",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        suffixIcon: Icon(Icons.calendar_today, size: 15.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.hp),

                    // TIME FIELD
                    TextField(
                      controller: controller.meetingTimeController,
                      readOnly: true,
                      onTap: isLoading ? null : controller.pickMeetingTime,
                      decoration: InputDecoration(
                        labelText: "Select Time",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        suffixIcon: Icon(Icons.access_time, size: 15.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.hp),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.hp,
                      child: ElevatedButton(
                        onPressed: isLoading
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
                                    "Confirming...",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Confirm",
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
