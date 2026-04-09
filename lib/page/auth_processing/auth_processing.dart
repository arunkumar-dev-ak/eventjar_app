import 'package:eventjar/controller/auth_processing/controller.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_loading.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_mobile_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AuthProcessingPage extends GetView<AuthProcessingController> {
  const AuthProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
      ),
      child: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.transparent,
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
