import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

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
          onPressed();
        },
        child: RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: "Log In",
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
