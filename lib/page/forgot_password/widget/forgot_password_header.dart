import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- Left Text Section -----
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 20.sp,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                GradientAutoSizeText(
                  content: "Enter your email to reset your password.",
                  textSize: 12.sp,
                  gradientStart: AppColors.gradientDarkStart,
                  gradientEnd: AppColors.gradientDarkEnd,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),

          // ----- Right Logo -----
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
