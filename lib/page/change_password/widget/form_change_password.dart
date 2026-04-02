import 'package:eventjar/controller/change_password/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:eventjar/global/responsive/responsive.dart';

class ChangePasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final RxBool isVisible;

  const ChangePasswordField({
    required this.controller,
    required this.label,
    required this.validator,
    required this.isVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller,
        obscureText: !isVisible.value,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 11.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible.value ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => isVisible.toggle(),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

class ChangePasswordForm extends StatelessWidget {
  final controller = Get.find<ChangePasswordController>();

  ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChangePasswordField(
                controller: controller.currentPwdController,
                label: "Current Password",
                validator: controller.validateCurrentPwd,
                isVisible: controller.state.isCurrentPwdVisible,
              ),

              SizedBox(height: 3.hp),

              ChangePasswordField(
                controller: controller.newPwdController,
                label: "New Password",
                validator: controller.validateNewPwd,
                isVisible: controller.state.isNewPwdVisible,
              ),

              SizedBox(height: 3.hp),

              ChangePasswordField(
                controller: controller.confirmPwdController,
                label: "Confirm Password",
                validator: controller.validateConfirmPwd,
                isVisible: controller.state.isConfirmPwdVisible,
              ),

              SizedBox(height: 5.hp),

              Obx(() {
                final isLoading = controller.state.isLoading.value;

                return GestureDetector(
                  onTap: isLoading ? null : controller.handleChangePassword,
                  child: Container(
                    width: 100.wp,
                    height: 7.hp,
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Change Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
