import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final DashboardController controller = Get.find();

  CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.state.selectedIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: LucideIcons.house,
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => _handleTap(0),
                ),
                _buildNavItem(
                  icon: LucideIcons.network,
                  label: 'Network',
                  isSelected: selectedIndex == 1,
                  onTap: () => _handleTap(1),
                ),
                _buildNavItem(
                  icon: LucideIcons.ticket,
                  label: 'Tickets',
                  isSelected: selectedIndex == 2,
                  onTap: () => _handleTap(2),
                ),
                _buildNavItem(
                  icon: LucideIcons.user,
                  label: 'Account',
                  isSelected: selectedIndex == 3,
                  onTap: () => _handleTap(3),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buttonGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : Colors.grey.shade500,
            ),
            SizedBox(height: 0.4.hp),
            Text(
              label,
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (index == 0) {
      controller.state.selectedIndex.value = index;
      if (!Get.isRegistered<HomeController>()) {
        Get.put(HomeController()).onTabOpen();
      } else {
        Get.find<HomeController>().onTabOpen();
      }
    } else if (index == 1) {
      controller.handleNetworkTabSwitch();
    } else if (index == 2) {
      controller.state.selectedIndex.value = index;
      if (!Get.isRegistered<MyTicketController>()) {
        Get.put(MyTicketController()).onTabOpen();
      } else {
        Get.find<MyTicketController>().onTabOpen();
      }
    } else if (index == 3) {
      controller.state.selectedIndex.value = index;
      if (!Get.isRegistered<UserProfileController>()) {
        Get.put(UserProfileController()).onTabOpen();
      } else {
        Get.find<UserProfileController>().onTabOpen();
      }
    }
  }
}
