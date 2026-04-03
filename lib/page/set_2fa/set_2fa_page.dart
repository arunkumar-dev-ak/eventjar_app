import 'dart:convert';

import 'package:eventjar/controller/set_2fa/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/set_2fa/widget/complete_set_2fa.dart';
import 'package:eventjar/page/set_2fa/widget/shimmer_set_2fa.dart';
import 'package:eventjar/page/set_2fa/widget/verify_set_2fa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Set2faPage extends GetView<Set2faController> {
  const Set2faPage({super.key});

  Uint8List getQrImageBytes(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradientFor(context)),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Obx(() {
          final step = controller.state.step.value;

          if (step == 'generate') return TwoFactorShimmer();
          if (step == 'verify') return Set2faVerifySection();

          return buildSet2faSuccess();
        }),
      ),
    );
  }
}
