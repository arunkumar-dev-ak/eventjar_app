import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpBackButton extends StatelessWidget {
  const SignUpBackButton({super.key});

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
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            isIOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
