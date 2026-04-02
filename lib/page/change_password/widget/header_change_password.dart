import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePasswordHeader extends StatelessWidget {
  const ChangePasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                GradientAutoSizeText(
                  content: "Update your password securely.",
                  textSize: 12.sp,
                  gradientStart: AppColors.gradientDarkStart,
                  gradientEnd: AppColors.gradientDarkEnd,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),

          SvgPicture.asset(
            'assets/event_jar_logo.svg',
            width: 5.wp,
            height: 5.hp,
          ),
        ],
      ),
    );
  }
}
