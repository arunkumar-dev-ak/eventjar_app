import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = GetPlatform.isIOS;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12),
      child: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
          Get.back();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Icon(
            isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
