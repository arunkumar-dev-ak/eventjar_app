import 'package:flutter/material.dart';

class AppColors {
  static const Color gradientDarkStart = Color(0xFF1C56BF); // Blue
  static const Color gradientDarkEnd = Color(0xFF167B4D); // Green
  static const Color eventInfoHeaderTextColor = Color.fromARGB(
    255,
    239,
    239,
    239,
  );

  static const Color gradientLightStart = Color(0xFF789ADE); // Blue
  static const Color gradientLightEnd = Color(0xFF49C987); // Green

  // Gradient definition
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [gradientLightStart, gradientLightEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [gradientDarkStart, gradientDarkEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient disabledButtonGradient = LinearGradient(
    colors: [Color(0xFFB0B0B0), Color(0xFF8E8E8E)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const placeHolderColor = Color(0xFFA2A2A2);
  static const splashScreenBackground = Color(0xFFCCE4FF);
  static const liteBlue = Color(0xFFE8F2FF);
}
