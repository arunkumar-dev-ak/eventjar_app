import 'package:eventjar/controller/signUp/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/sign_up/widgets/signup_back_button.dart';
import 'package:eventjar/page/sign_up/widgets/signup_form.dart';
import 'package:eventjar/page/sign_up/widgets/signup_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Container(
          width: 100.wp,
          decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*----- back button -----*/
                SignUpBackButton(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SignUpHeader(),
                      SizedBox(height: 3.hp),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        width: 100.wp,
                        height: 40,
                      ),
                      /*----- Form -----*/
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 5.wp,
                              right: 5.wp,
                              bottom: 5.wp,
                            ),
                            child: SingleChildScrollView(child: SignUpForm()),
                          ),
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
    );
  }
}
