import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/gradient_text.dart';
import 'package:eventjar/routes/route_name.dart';
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
          //Budget Tracker Icon
          // GestureDetector(
          //   onTap: () {
          // Navigate to budget/wallet page
          // Get.toNamed(RouteName.budgetPage);
          //   },
          //   child: _buildBudgetIcon(),
          // ),
          SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildBudgetIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 40,
      height: 40,
      child: Center(
        child: Icon(
          Icons.currency_exchange_rounded,
          size: 22,
          color: Color(
            0xFFD4AF37,
          ), // Classic gold - BEST for blue-green gradient
        ),
      ),
    );
  }
}
