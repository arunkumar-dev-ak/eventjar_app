import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class InstructionSection extends StatelessWidget {
  const InstructionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.wp),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          InstructionStep(step: 1, text: "Install an authenticator app"),
          InstructionStep(step: 2, text: "Scan QR or enter secret manually"),
          InstructionStep(step: 3, text: "Enter the 6-digit code below"),
        ],
      ),
    );
  }
}

class InstructionStep extends StatelessWidget {
  final int step;
  final String text;

  const InstructionStep({super.key, required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.2.hp),
      child: Row(
        children: [
          Container(
            width: 5.wp,
            height: 5.wp,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(
              "$step",
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondary(context)),
            ),
          ),
        ],
      ),
    );
  }
}
