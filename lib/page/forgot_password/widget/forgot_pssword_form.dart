import 'package:eventjar/controller/forgotPassword/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/forgot_password/widget/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final RxBool isFieldValid;
  final RxBool isFieldFocused;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const ForgotPasswordTextFormField({
    required this.controller,
    required this.label,
    required this.validator,
    required this.isFieldValid,
    required this.isFieldFocused,
    required this.focusNode,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        isFieldFocused.value = hasFocus;
      },
      child: Obx(
        () => TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          onChanged: onChanged,
          focusNode: focusNode,
          decoration: InputDecoration(
            label: RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(
                  color: !isFieldValid.value
                      ? Colors.red
                      : isFieldFocused.value
                      ? Colors.black
                      : Colors.grey,
                  fontSize: 11.sp,
                ),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(Icons.email, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordController controller = Get.find();

  ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.hp),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email
            ForgotPasswordTextFormField(
              controller: controller.emailController,
              label: "Email",
              validator: (val) => controller.validateEmail(val),
              isFieldValid: controller.state.isEmailValid,
              isFieldFocused: controller.state.focusEmail,
              onChanged: controller.updateEmailValidity,
              focusNode: controller.emailFocusNode,
            ),
            SizedBox(height: 4.hp),
            //submit button
            ForgotPasswordSubmitButton(),
          ],
        ),
      ),
    );
  }
}
