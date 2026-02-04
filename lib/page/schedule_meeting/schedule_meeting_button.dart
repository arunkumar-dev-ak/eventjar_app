import 'package:eventjar/controller/schedule_meeting/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleMeetingActionButtons extends StatelessWidget {
  final ScheduleMeetingController controller;

  const ScheduleMeetingActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.state.isLoading.value;
      final configLoading = controller.state.configLoading.value;
      final hasMethodsSelected = controller.hasAnyMethodSelected;

      // ✅ Button disabled if: loading OR configLoading OR no methods selected
      final isButtonEnabled =
          !isLoading && !configLoading && hasMethodsSelected;

      return SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            // Reset Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  textStyle: TextStyle(fontSize: 9.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: (isLoading || configLoading)
                    ? null
                    : () => controller.resetForm(),
                child: Text('Reset', style: TextStyle(fontSize: 9.sp)),
              ),
            ),
            SizedBox(width: 2.wp),

            // ✅ Schedule Button - DISABLED logic
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? Colors.blue
                      : Colors.grey.shade300,
                  foregroundColor: isButtonEnabled
                      ? Colors.white
                      : Colors.grey.shade500,
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  textStyle: TextStyle(fontSize: 9.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isButtonEnabled ? 2 : 0,
                ),
                onPressed: isButtonEnabled
                    ? () {
                        if (controller.formKey.currentState?.validate() ??
                            false) {
                          controller.scheduleMeeting(context);
                        }
                      }
                    : null,
                child: isLoading || configLoading
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        configLoading
                            ? 'Loading Config...'
                            : 'Schedule Meeting',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: isButtonEnabled
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
