import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthSignIn extends StatelessWidget {
  final Function onPressed;
  const AuthSignIn({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(AppColors.gradientLightStart),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
          ),
        ),
        onPressed: () {
          HapticHelper.light();
          onPressed();
        },
        child: RichText(
          text: TextSpan(
            text: "${'already_have_an_account'.tr}? ",
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: 'log_in'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
