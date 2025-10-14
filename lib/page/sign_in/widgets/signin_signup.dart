import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class AuthSignUp extends StatelessWidget {
  final Function onPressed;
  const AuthSignUp({required this.onPressed, super.key});

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
          onPressed();
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: "Create Account",
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
