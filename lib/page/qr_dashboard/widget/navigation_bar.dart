import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrDashboardBottomNavigation extends StatelessWidget {
  final QrDashboardController controller = Get.find();

  QrDashboardBottomNavigation({super.key});

  static TextStyle optionStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.state.selectedIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.gradientDarkStart,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: optionStyle.copyWith(
            color: AppColors.gradientDarkStart,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: optionStyle.copyWith(
            color: Colors.grey.shade500,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            _createBottomNavigationItem(
              filledIcon: Icons.qr_code,
              outlinedIcon: Icons.qr_code_outlined,
              label: "Generate",
              isSelected: selectedIndex == 0,
            ),
            _createBottomNavigationItem(
              filledIcon: Icons.qr_code_scanner,
              outlinedIcon: Icons.qr_code_scanner_outlined,
              label: "Scan",
              isSelected: selectedIndex == 1,
            ),
            _createBottomNavigationItem(
              filledIcon: Icons.person_add,
              outlinedIcon: Icons.person_add_outlined,
              label: "Add",
              isSelected: selectedIndex == 2,
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (index) {
            controller.state.selectedIndex.value = index;
          },
        ),
      );
    });
  }

  BottomNavigationBarItem _createBottomNavigationItem({
    required String label,
    required IconData filledIcon,
    required IconData outlinedIcon,
    required bool isSelected,
  }) {
    Widget iconWidget;
    if (isSelected) {
      iconWidget = _buildSelectedIcon(filledIcon);
    } else {
      iconWidget = _buildUnselectedIcon(outlinedIcon);
    }

    return BottomNavigationBarItem(icon: iconWidget, label: label);
  }

  Widget _buildSelectedIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: AppColors.gradientDarkStart, size: 24),
    );
  }

  Widget _buildUnselectedIcon(IconData iconData) {
    return Icon(iconData, color: Colors.grey.shade500, size: 24);
  }
}
