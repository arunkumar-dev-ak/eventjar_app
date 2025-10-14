import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Join Us!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 20.sp,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 0.5.hp),
              GradientText(
                content: "Create your account",
                textSize: 14.sp,
                gradientStart: AppColors.gradientDarkStart,
                gradientEnd: AppColors.gradientDarkEnd,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),

          // Right side logo
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
