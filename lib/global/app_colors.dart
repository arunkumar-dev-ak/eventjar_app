import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // ── Dark theme colors ──
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkCardElevated = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF3A3A3A);
  static const Color darkBorder = Color(0xFF3A3A3A);

  // ── Theme-aware helpers (use with BuildContext) ──

  /// Scaffold / page background
  static Color scaffoldBg(BuildContext context) =>
      _isDark(context) ? darkBackground : Colors.grey.shade50;

  /// Card / container background
  static Color cardBg(BuildContext context) =>
      _isDark(context) ? darkCard : Colors.white;

  /// Elevated card background (for nested cards)
  static Color cardElevatedBg(BuildContext context) =>
      _isDark(context) ? darkCardElevated : Colors.white;

  /// Primary text color
  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? Colors.white : Colors.black87;

  /// Secondary text color
  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? Colors.grey.shade400 : Colors.grey.shade600;

  /// Hint / placeholder text
  static Color textHint(BuildContext context) =>
      _isDark(context) ? Colors.grey.shade500 : Colors.grey.shade500;

  /// Divider color
  static Color divider(BuildContext context) =>
      _isDark(context) ? darkDivider : Colors.grey.shade200;

  /// Border color
  static Color border(BuildContext context) =>
      _isDark(context) ? darkBorder : Colors.grey.shade300;

  /// Shadow color (transparent in dark mode)
  static Color shadow(BuildContext context) =>
      _isDark(context) ? Colors.transparent : Colors.grey.shade200;

  /// Icon color (muted)
  static Color iconMuted(BuildContext context) =>
      _isDark(context) ? Colors.grey.shade400 : Colors.grey.shade500;

  /// Light blue tinted background
  static Color lightBlueBg(BuildContext context) =>
      _isDark(context) ? const Color(0xFF1A2A3A) : Colors.blue.shade50;

  /// Light blue border
  static Color lightBlueBorder(BuildContext context) =>
      _isDark(context) ? const Color(0xFF2A3A4A) : Colors.blue.shade100;

  /// Chip / tag background
  static Color chipBg(BuildContext context) =>
      _isDark(context) ? darkCardElevated : Colors.grey.shade100;

  /// Search bar / input background
  static Color inputBg(BuildContext context) =>
      _isDark(context) ? darkCardElevated : Colors.grey.shade100;

  /// AppBar gradient for dark mode
  static LinearGradient appBarGradientFor(BuildContext context) =>
      _isDark(context)
      ? const LinearGradient(
          colors: [Color(0xFF1A3A6B), Color(0xFF1A5A3A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
      : appBarGradient;

  /// Button gradient for dark mode
  static LinearGradient buttonGradientFor(BuildContext context) =>
      _isDark(context)
      ? const LinearGradient(
          colors: [Color(0xFF2A66CF), Color(0xFF1E8B5D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
      : buttonGradient;

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// For use in free functions without BuildContext (uses GetX)
  static bool get isDark => Get.isDarkMode;

  // ── Static getters (no context needed, uses Get.isDarkMode) ──

  static Color get scaffoldBgStatic =>
      isDark ? darkBackground : Colors.grey.shade50;
  static Color get cardBgStatic => isDark ? darkCard : Colors.white;
  static Color get cardElevatedBgStatic =>
      isDark ? darkCardElevated : Colors.white;
  static Color get textPrimaryStatic => isDark ? Colors.white : Colors.black87;
  static Color get textSecondaryStatic =>
      isDark ? Colors.grey.shade400 : Colors.grey.shade600;
  static Color get textHintStatic =>
      isDark ? Colors.grey.shade500 : Colors.grey.shade500;
  static Color get dividerStatic => isDark ? darkDivider : Colors.grey.shade200;
  static Color get borderStatic => isDark ? darkBorder : Colors.grey.shade300;
  static Color get shadowStatic =>
      isDark ? Colors.transparent : Colors.grey.shade200;
  static Color get iconMutedStatic =>
      isDark ? Colors.grey.shade400 : Colors.grey.shade500;
  static Color get lightBlueBgStatic =>
      isDark ? const Color(0xFF1A2A3A) : Colors.blue.shade50;
  static Color get lightBlueBorderStatic =>
      isDark ? const Color(0xFF2A3A4A) : Colors.blue.shade100;
  static Color get chipBgStatic =>
      isDark ? darkCardElevated : Colors.grey.shade100;
  static Color get inputBgStatic =>
      isDark ? darkCardElevated : Colors.grey.shade100;
  static Color get greyBgStatic =>
      isDark ? darkCardElevated : Colors.grey.shade200;
}
