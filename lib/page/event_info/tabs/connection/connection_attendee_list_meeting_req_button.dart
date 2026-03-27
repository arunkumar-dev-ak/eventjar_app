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
    final buttonId = attendeeId;

    return Obx(() {
      final isButtonLoading =
          controller.state.meetReqButtonLoadingStates[buttonId] ?? false;
      final isProcessing = controller.state.isMeetReqProcessingRequest.value;
      final isDisabled = isButtonLoading || isProcessing;

      return GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDisabled
                  ? [Colors.grey.shade300, Colors.grey.shade400]
                  : [const Color(0xFF1565C0), const Color(0xFF1E88E5)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: isButtonLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 9.5.sp,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
