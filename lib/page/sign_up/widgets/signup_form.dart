import 'package:eventjar_app/controller/signUp/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/page/sign_up/widgets/signup_signin.dart';
import 'package:eventjar_app/page/sign_up/widgets/signup_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isPasswordHidden;
  final VoidCallback togglePasswordVisibility;
  final RxBool isFieldValid;
  final RxBool isFieldFocused;
  final Function(String) onChanged;

  const SignUpTextFormField({
    required this.controller,
    required this.label,
    required this.validator,
    this.isPassword = false,
    this.isPasswordHidden = false,
    required this.togglePasswordVisibility,
    required this.isFieldValid,
    required this.isFieldFocused,
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
          obscureText: isPassword && isPasswordHidden,
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
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade400,
                    ),
                  )
                : null,
            prefixIcon: Icon(_getFieldIcon(label), color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final SignUpController controller = Get.find();

  SignUpForm({super.key});

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
            // Full Name
            SignUpTextFormField(
              controller: controller.fullNameController,
              label: "Full Name",
              validator: (val) => val!.isEmpty ? "Full Name is required" : null,
              isFieldValid: controller.state.isFullNamelValid,
              isFieldFocused: controller.state.focusFullName,
              togglePasswordVisibility: () {},
              onChanged: (_) {},
            ),
            SizedBox(height: 2.hp),

            // Email
            SignUpTextFormField(
              controller: controller.emailController,
              label: "Email",
              validator: (val) => val!.isEmpty ? "Email is required" : null,
              isFieldValid: controller.state.isEmailValid,
              isFieldFocused: controller.state.focusEmail,
              togglePasswordVisibility: () {},
              onChanged: (_) {},
            ),
            SizedBox(height: 2.hp),

            // Mobile Number
            SignUpTextFormField(
              controller: controller.mobileNumberController,
              label: "Mobile Number",
              validator: (val) =>
                  val!.isEmpty ? "Mobile Number is required" : null,
              isFieldValid: controller.state.isMobileNumberValid,
              isFieldFocused: controller.state.focusMobileNumber,
              togglePasswordVisibility: () {},
              onChanged: (_) {},
            ),
            SizedBox(height: 2.hp),

            // Password
            Obx(
              () => SignUpTextFormField(
                controller: controller.passwordController,
                label: "Password",
                isPassword: true,
                isPasswordHidden: controller.state.isPasswordHidden.value,
                togglePasswordVisibility: () =>
                    controller.state.isPasswordHidden.value =
                        !controller.state.isPasswordHidden.value,
                validator: (val) =>
                    val!.isEmpty ? "Password is required" : null,
                isFieldValid: controller.state.isPasswordValid,
                isFieldFocused: controller.state.focusPassword,
                onChanged: (_) {},
              ),
            ),
            SizedBox(height: 2.hp),

            // Confirm Password
            Obx(
              () => SignUpTextFormField(
                controller: controller.confirmPasswordController,
                label: "Confirm Password",
                isPassword: true,
                isPasswordHidden:
                    controller.state.isConfirmPasswordHidden.value,
                togglePasswordVisibility: () =>
                    controller.state.isConfirmPasswordHidden.value =
                        !controller.state.isConfirmPasswordHidden.value,
                validator: (val) =>
                    val!.isEmpty ? "Confirm Password is required" : null,
                isFieldValid: controller.state.isConfirmPasswordValid,
                isFieldFocused: controller.state.focusConfirmPassword,
                onChanged: (_) {},
              ),
            ),
            SizedBox(height: 3.hp),

            //submit button
            SignUpSubmitButton(),
            SizedBox(height: 3.hp),
            // Divider with OR
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.grey.shade300, thickness: 1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.wp),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.grey.shade300, thickness: 1),
                ),
              ],
            ),

            SizedBox(height: 2.hp),
            AuthSignIn(
              onPressed: () {
                controller.navigateToLogin();
              },
            ),
            SizedBox(height: 0.5.hp),
          ],
        ),
      ),
    );
  }
}

IconData _getFieldIcon(String label) {
  switch (label) {
    case "Full Name":
      return Icons.person;
    case "Email":
      return Icons.email;
    case "Mobile Number":
      return Icons.phone;
    case "Password":
    case "Confirm Password":
      return Icons.lock;
    default:
      return Icons.text_fields;
  }
}
