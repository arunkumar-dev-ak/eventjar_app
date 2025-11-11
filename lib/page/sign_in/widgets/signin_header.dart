import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 20.sp,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 0.5.hp),
              GradientText(
                content: "Sign in to continue",
                textSize: 14.sp,
                gradientStart: AppColors.gradientDarkStart,
                gradientEnd: AppColors.gradientDarkEnd,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SvgPicture.asset(
            'assets/event_jar_logo.svg',
            width: 5.wp,
            height: 5.hp,
            semanticsLabel: 'Event Jar Logo',
          ),
        ],
      ),
    );
  }
}
