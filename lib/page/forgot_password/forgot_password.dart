import 'package:eventjar_app/controller/forgotPassword/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/page/forgot_password/widget/forgot_password_back_button.dart';
import 'package:eventjar_app/page/forgot_password/widget/forgot_password_header.dart';
import 'package:eventjar_app/page/forgot_password/widget/forgot_pssword_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White icons (Android)
        statusBarBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: 100.wp,
            decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*----- back button -----*/
                  ForgotPasswordBackButton(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ForgotPasswordHeader(),
                        SizedBox(height: 5.hp),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                width: 100.wp,
                                height: 30,
                              ),
                              /*----- Form -----*/
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5.wp,
                                      right: 5.wp,
                                      bottom: 5.wp,
                                    ),
                                    child: SingleChildScrollView(
                                      child: ForgotPasswordForm(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
