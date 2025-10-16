import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo
          Image.asset(
            controller.logoPath,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
          //header
          GradientText(
            textSize: 13.sp,
            content: controller.appBarTitle,
            gradientStart: AppColors.gradientDarkStart,
            gradientEnd: AppColors.gradientDarkEnd,
            fontWeight: FontWeight.bold,
          ),
          //Profile
          Container(
            decoration: BoxDecoration(
              color: AppColors.splashScreenBackground,
              borderRadius: BorderRadius.circular(50),
            ),
            width: 40,
            height: 40,
            child: Center(
              child: GradientText(
                textSize: 15.sp,
                content: "A",
                gradientStart: AppColors.gradientDarkStart,
                gradientEnd: AppColors.gradientDarkEnd,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
