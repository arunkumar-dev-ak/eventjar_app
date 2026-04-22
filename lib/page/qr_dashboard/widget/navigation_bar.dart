import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class QrDashboardBottomNavigation extends StatelessWidget {
  final QrDashboardController controller = Get.find();

  QrDashboardBottomNavigation({super.key});

  static TextStyle optionStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final myQr = Get.find<MyQrScreenController>();
    return Obx(() {
      final selectedIndex = controller.state.selectedIndex.value;

      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          border: isDark
              ? Border(top: BorderSide(color: AppColors.border(context), width: 0.5))
              : null,
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadow(context),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Showcase(
                    key: myQr.tourMyQrTabKey,
                    title: 'My QR',
                    description:
                        'Your shareable QR lives here — show it to save your contact in others\' phones.',
                    tooltipBackgroundColor: const Color(0xFF00C853),
                    textColor: Colors.white,
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    descTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    child: _buildNavButton(
                      icon: Icons.qr_code,
                      label: "My QR",
                      isSelected: selectedIndex == 0,
                      gradient: LinearGradient(
                        colors: [Color(0xFF00C853), Color(0xFF1DE9B6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      onTap: () => _onTabTap(0),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Showcase(
                    key: myQr.tourScanQrTabKey,
                    title: 'Scan QR',
                    description:
                        'Switch here to point your camera at someone else\'s QR and instantly add them.',
                    tooltipBackgroundColor: const Color(0xFF2196F3),
                    textColor: Colors.white,
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    descTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    child: _buildNavButton(
                      icon: Icons.qr_code_scanner,
                      label: "Scan QR",
                      isSelected: selectedIndex == 1,
                      gradient: LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      onTap: () => _onTabTap(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withValues(alpha: 0.3),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: isSelected ? gradient : null,
            color: isSelected ? null : AppColors.chipBgStatic,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? null
                : Border.all(color: AppColors.borderStatic, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondaryStatic,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondaryStatic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTap(int index) {
    controller.state.selectedIndex.value = index;

    if (index == 0) {
      // Stop camera when switching to My QR tab
      if (Get.isRegistered<QrScanScreenController>()) {
        Get.find<QrScanScreenController>().stopCamera();
      }

      if (!Get.isRegistered<MyQrScreenController>()) {
        Get.put(MyQrScreenController()).onTabOpen();
      } else {
        Get.find<MyQrScreenController>().onTabOpen();
      }
    } else if (index == 1) {
      // Start camera when switching to Scan QR tab
      if (!Get.isRegistered<QrScanScreenController>()) {
        Get.put(QrScanScreenController()).onTabOpen();
      } else {
        Get.find<QrScanScreenController>().onTabOpen();
      }
    }
  }
}
