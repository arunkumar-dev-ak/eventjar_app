import 'package:eventjar_app/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoBackButton extends StatelessWidget {
  const EventInfoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect platform
    final bool isIOS = GetPlatform.isIOS;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            isIOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
