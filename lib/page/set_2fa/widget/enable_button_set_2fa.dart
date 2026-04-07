import 'package:eventjar/controller/set_2fa/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class Enable2FAButton extends GetView<Set2faController> {
  const Enable2FAButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: state.isLoading.value ? null : controller.enable2FA,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: state.isLoading.value
                    ? [Colors.blue.shade300, Colors.blue.shade200]
                    : [Colors.blue.shade600, Colors.blue.shade400],
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.8.hp),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.isLoading.value)
                    const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  SizedBox(width: 2.wp),
                  Text(
                    state.isLoading.value
                        ? "Enabling..."
                        : "Enable Two-Factor Authentication",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
