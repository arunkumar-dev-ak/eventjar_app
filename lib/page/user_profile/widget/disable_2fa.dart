import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Disable2faDialog extends GetView<UserProfileController> {
  const Disable2faDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.state.isDisabling2FA.value;

      return PopScope(
        canPop: !isLoading,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                      Text(
                        "Disable 2FA",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 1.hp),

                      Text(
                        "For security, please enter your password to disable 2FA.",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 2.hp),

                      Text(
                        "This will reduce the security of your account. You can re-enable it at any time.",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 3.hp),

                      // 🔐 Password Field
                      TextField(
                        controller: controller.disablePasswordController,
                        obscureText: !controller.state.isDisable2FAToggle.value,
                        decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.state.isDisable2FAToggle.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.state.isDisable2FAToggle.value =
                                  !controller.state.isDisable2FAToggle.value;
                            },
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
                              : controller.confirmDisable2FA,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
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
                                      "Disabling...",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Disable 2FA",
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
        ),
      );
    });
  }
}
