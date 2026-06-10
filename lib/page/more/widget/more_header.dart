import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/theme_store.dart';
import 'package:eventjar/global/whatsapp_chat.dart';
import 'package:eventjar/global/widget/language_change_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MoreHeader extends StatelessWidget {
  final bool isDark;

  const MoreHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.wp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'explore'.tr,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 0.5,
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AppColors.gradientDarkStart,
                      AppColors.gradientDarkEnd,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    "MyEventJar",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildThemeToggle(context),
              SizedBox(width: 1.wp),
              _buildLanguageButton(context),
              SizedBox(width: 1.wp),
              _buildWhatsAppButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final iconColor =
        isDark ? const Color(0xFF5B9BEF) : AppColors.gradientDarkStart;
    return Obx(() {
      final mode = ThemeStore.to.themeMode;
      final IconData icon = switch (mode) {
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.system => Icons.phone_android_rounded,
      };
      return PopupMenuButton<ThemeMode>(
        icon: Icon(icon, color: iconColor),
        tooltip: 'theme'.tr,
        onSelected: (selected) => ThemeStore.to.setThemeMode(selected),
        itemBuilder: (_) => [
          _buildThemeMenuItem(
            ThemeMode.light,
            Icons.light_mode_rounded,
            'light'.tr,
            mode,
          ),
          _buildThemeMenuItem(
            ThemeMode.dark,
            Icons.dark_mode_rounded,
            'dark'.tr,
            mode,
          ),
          _buildThemeMenuItem(
            ThemeMode.system,
            Icons.phone_android_rounded,
            'system_default'.tr,
            mode,
          ),
        ],
      );
    });
  }

  PopupMenuItem<ThemeMode> _buildThemeMenuItem(
    ThemeMode mode,
    IconData icon,
    String label,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.gradientDarkStart : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? AppColors.gradientDarkStart : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 18, color: AppColors.gradientDarkStart),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    final iconColor =
        isDark ? const Color(0xFF5B9BEF) : AppColors.gradientDarkStart;
    return IconButton(
      icon: Icon(Icons.language, color: iconColor),
      tooltip: 'language'.tr,
      onPressed: () => showLanguageChangeDialog(context),
    );
  }

  Widget _buildWhatsAppButton(BuildContext context) {
    return IconButton(
      icon: FaIcon(
        FontAwesomeIcons.whatsapp,
        color: const Color(0xFF25D366),
      ),
      tooltip: 'Support',
      onPressed: () => WhatsAppHelper.openSupport(context: context),
    );
  }
}
