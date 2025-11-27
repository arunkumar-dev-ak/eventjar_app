import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionAttendeeListCustomSendButton extends StatelessWidget {
  final String label;
  final String attendeeId;
  final VoidCallback? onPressed;

  const ConnectionAttendeeListCustomSendButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.attendeeId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventInfoController>();
    final buttonId = attendeeId; // ✅ Use attendeeId directly as key

    return Obx(() {
      // ✅ Use meetReqButtonLoadingStates instead
      final isButtonLoading =
          controller.state.meetReqButtonLoadingStates[buttonId] ?? false;
      final isProcessing = controller.state.isMeetReqProcessingRequest.value;

      return ElevatedButton(
        onPressed: (isButtonLoading || isProcessing) ? null : onPressed,
        style:
            ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.zero,
              elevation: 1,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) => Colors.transparent,
              ),
              elevation: WidgetStateProperty.resolveWith<double>((states) => 0),
            ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (isButtonLoading)
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : [Colors.blueAccent, Colors.lightBlueAccent],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.all(1.wp),
            constraints: BoxConstraints(minWidth: 88),
            alignment: Alignment.center,
            child: isButtonLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 7.5.sp,
                      letterSpacing: 0.2,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
