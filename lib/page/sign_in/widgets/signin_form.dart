import 'package:eventjar/controller/signIn/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/social_auth/google_auth.dart';
import 'package:eventjar/global/social_auth/social_login_button.dart';
import 'package:eventjar/global/widget/alignment_widget.dart';
import 'package:eventjar/page/sign_in/widgets/signin_signup.dart';
import 'package:eventjar/page/sign_in/widgets/signin_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isPasswordHidden;
  final VoidCallback togglePasswordVisibility;
  final RxBool isFieldValid;
  final RxBool isFieldFocused;
  final Function(String) onChanged;
  final double fontSize;

  const LoginTextFormField({
    required this.controller,
    required this.label,
    required this.validator,
    required this.isPassword,
    required this.isPasswordHidden,
    required this.togglePasswordVisibility,
    required this.isFieldValid,
    required this.isFieldFocused,
    required this.onChanged,
    this.fontSize = 12, // default font size
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
            labelText: label,
            labelStyle: TextStyle(
              color: !isFieldValid.value
                  ? Colors.red
                  : isFieldFocused.value
                  ? AppColors.textPrimary(context)
                  : AppColors.textHint(context),
              fontSize: fontSize.sp,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.border(context)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textPrimary(context), width: 2),
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
            prefixIcon: Icon(_getFieldIcon(label), color: AppColors.iconMuted(context)),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.iconMuted(context),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

IconData _getFieldIcon(String label) {
  switch (label) {
    case "Email":
      return Icons.email;
    case "Password":
      return Icons.lock;
    default:
      return Icons.text_fields;
  }
}

class SignInForm extends StatelessWidget {
  final SignInController controller = Get.find();

  SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.shadow(context), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.hp),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginTextFormField(
              controller: controller.emailController,
              label: "Email",
              validator: controller.validateEmail,
              isPassword: false,
              isPasswordHidden: false,
              togglePasswordVisibility: () {},
              isFieldValid: controller.state.isEmailValid,
              isFieldFocused: controller.state.focusEmail,
              onChanged: controller.updateEmailValidity,
              fontSize: 11,
            ),
            SizedBox(height: 2.hp),

            Obx(
              () => LoginTextFormField(
                controller: controller.passwordController,
                label: "Password",
                validator: controller.validatePassword,
                isPassword: true,
                isPasswordHidden: controller.state.isPasswordHidden.value,
                togglePasswordVisibility: controller.togglePasswordVisibility,
                isFieldValid: controller.state.isPasswordValid,
                isFieldFocused: controller.state.focusPassword,
                onChanged: controller.updatePasswordValidity,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 0.5.hp),

            /*----- forgot pwd -----*/
            IgnorePointer(
              ignoring: controller.state.isLoading.value,
              child: AlignmentWidget(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 226, 226, 226),
                    ),
                  ),
                  onPressed: () async {
                    controller.navigateToForgotPassword();
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: AppColors.placeHolderColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.5.hp),

            //submit button
            SignInSubmitButton(),
            SizedBox(height: 3.hp),
            // Divider with OR
            Row(
              children: [
                Expanded(
                  child: Divider(color: AppColors.divider(context), thickness: 1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.wp),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: AppColors.textHint(context),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: AppColors.divider(context), thickness: 1),
                ),
              ],
            ),

            /*----- Social Logins -----*/
            SizedBox(height: 3.hp),

            Row(
              children: [
                Expanded(
                  child: SocialButton(
                    text: "Continue With Google",
                    assetPath: "assets/app_icon/google.png",
                    color: Colors.red,
                    onTap: () => AuthService().signInWithGoogle(
                      onSuccess: (idToken) =>
                          controller.navigateToAuthProcessign(idToken),
                    ),
                  ),
                ),
                // SizedBox(width: 3.wp),
                //     Expanded(
                //       child: SocialButton(
                //         text: "LinkedIn",
                //         assetPath: "assets/app_icon/linkedin.png",
                //         color: Colors.blue,
                //         onTap: () {},
                //       ),
                //     ),
              ],
            ),

            SizedBox(height: 4.hp),
            AuthSignUp(
              onPressed: () {
                controller.navigateToSignUp();
              },
            ),
            SizedBox(height: 0.5.hp),
          ],
        ),
      ),
    );
  }
}
