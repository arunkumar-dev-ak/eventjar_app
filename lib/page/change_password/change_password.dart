import 'package:eventjar/controller/change_password/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/auth_back_button.dart';
import 'package:eventjar/page/change_password/widget/form_change_password.dart';
import 'package:eventjar/page/change_password/widget/header_change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: 100.wp,
            decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthBackButton(),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ChangePasswordHeader(),
                        SizedBox(height: 5.hp),

                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100.wp,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  width: 100.wp,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.wp,
                                      vertical: 5.wp,
                                    ),
                                    child: SingleChildScrollView(
                                      child: ChangePasswordForm(),
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
