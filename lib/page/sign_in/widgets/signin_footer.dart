import 'package:eventjar/controller/signIn/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInFooter extends StatelessWidget {
  final SignInController controller = Get.find<SignInController>();
  SignInFooter({super.key});

  Widget textButtonWidget({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(AppColors.gradientLightStart),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryStatic,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     textButtonWidget(label: "Privacy Policy", onPressed: () {}),
          //     Container(
          //       width: 4,
          //       height: 4,
          //       margin: EdgeInsets.symmetric(horizontal: 2.wp),
          //       decoration: BoxDecoration(
          //         color: Colors.grey.shade400,
          //         shape: BoxShape.circle,
          //       ),
          //     ),
          //     textButtonWidget(label: "Contact Us", onPressed: () {}),
          //     Container(
          //       width: 4,
          //       height: 4,
          //       margin: EdgeInsets.symmetric(horizontal: 2.wp),
          //       decoration: BoxDecoration(
          //         color: Colors.grey.shade400,
          //         shape: BoxShape.circle,
          //       ),
          //     ),
          //     textButtonWidget(label: "Terms", onPressed: () {}),
          //   ],
          // ),
          Text(
            "© 2025 EventJar. All rights reserved.",
            style: TextStyle(color: AppColors.textHint(context), fontSize: 9.sp),
          ),
          SizedBox(height: 0.5.hp),
          RichText(
            text: TextSpan(
              text: "Developed by ",
              style: TextStyle(color: AppColors.textSecondary(context), fontSize: 10.sp),
              children: [
                TextSpan(
                  text: "Humbletree Cloud Pvt Ltd",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gradientDarkStart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
