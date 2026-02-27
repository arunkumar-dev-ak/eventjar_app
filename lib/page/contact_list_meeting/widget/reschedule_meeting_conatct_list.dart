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
    return PopScope(
      canPop: !controller.state.isRescheduling.value,
      onPopInvokedWithResult: (didPop, result) {
        if (controller.state.isRescheduling.value) {
          AppSnackbar.warning(
            title: "Please wait",
            message: "Rescheduling in progress...",
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(20.wp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reschedule Meeting",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20.hp),

            /// DATE FIELD
            TextField(
              controller: controller.meetingDateController,
              readOnly: true,
              onTap: controller.pickMeetingDate,
              decoration: InputDecoration(
                labelText: "Select Date",
                suffixIcon: Icon(Icons.calendar_today, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 12.hp),

            /// TIME FIELD
            TextField(
              controller: controller.meetingTimeController,
              readOnly: true,
              onTap: controller.pickMeetingTime,
              decoration: InputDecoration(
                labelText: "Select Time",
                suffixIcon: Icon(Icons.access_time, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 24.hp),

            /// CONFIRM BUTTON
            // Obx(() {
            //   final isLoading = controller.state.isRescheduling.value;
            //   return SizedBox(
            //     width: double.infinity,
            //     height: 48.hp,
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blueAccent,
            //         elevation: 4,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //       ),
            //       onPressed: isLoading
            //           ? null
            //           : () => controller.rescheduleMeeting(
            //               context: context,
            //               meetingId: meetingId,
            //             ),
            //       child: isLoading
            //           ? Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 SizedBox(
            //                   height: 18.hp,
            //                   width: 18.hp,
            //                   child: const CircularProgressIndicator(
            //                     strokeWidth: 2,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 SizedBox(width: 10.wp),
            //                 Text(
            //                   "Confirming...",
            //                   style: TextStyle(
            //                     fontSize: 14.sp,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //               ],
            //             )
            //           : Text(
            //               "Confirm",
            //               style: TextStyle(
            //                 fontSize: 15.sp,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //     ),
            //   );
            // }),
          ],
        ),
      ),
    );
  }
}
