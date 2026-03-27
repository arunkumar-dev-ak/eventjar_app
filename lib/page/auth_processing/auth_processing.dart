import 'package:eventjar/controller/auth_processing/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_loading.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_mobile_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AuthProcessingPage extends GetView<AuthProcessingController> {
  const AuthProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(() {
            if (controller.state.isMobileNumberRequired.value) {
              return AuthProcessignMobileNumber();
            } else {
              return AuthProcessignLoading();
            }
          }),
        ),
      ),
    );
  }
}
