import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final DashboardController controller = Get.find();

  CustomBottomNavigationBar({super.key});

  static TextStyle optionStyle = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.state.selectedIndex.value;

      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: AppColors.gradientDarkStart,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: optionStyle.copyWith(color: Colors.grey.shade900),
        unselectedLabelStyle: optionStyle.copyWith(color: Colors.grey.shade500),
        items: [
          _createBottomNavigationItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
            label: "Home",
            isSelected: selectedIndex == 0,
          ),
          _createBottomNavigationItem(
            filledIcon: LucideIcons.network,
            outlinedIcon: LucideIcons.network,
            label: "Network",
            isSelected: selectedIndex == 1,
          ),
          _createBottomNavigationItem(
            filledIcon: Icons.account_circle,
            outlinedIcon: Icons.account_circle_outlined,
            label: "Account",
            isSelected: selectedIndex == 2,
          ),
          _createBottomNavigationItem(
            filledIcon: FontAwesomeIcons.ticket,
            outlinedIcon: LucideIcons.ticket,
            label: "Tickets",
            isSelected: selectedIndex == 3,
            isFontAwesome: true,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 0) {
            controller.state.selectedIndex.value = index;
            if (!Get.isRegistered<HomeController>()) {
              Get.put(HomeController()).onTabOpen();
            }
            Get.find<HomeController>().onTabOpen();
          } else if (index == 1) {
            controller.handleNetworkTabSwitch();
          } else if (index == 2) {
            controller.state.selectedIndex.value = index;
            if (!Get.isRegistered<UserProfileController>()) {
              Get.put(UserProfileController()).onTabOpen();
            }
            Get.find<UserProfileController>().onTabOpen();
          } else if (index == 3) {
            controller.state.selectedIndex.value = index;
            if (!Get.isRegistered<MyTicketController>()) {
              Get.put(MyTicketController()).onTabOpen();
            }
            Get.find<MyTicketController>().onTabOpen();
          }
        },
      );
    });
  }

  BottomNavigationBarItem _createBottomNavigationItem({
    required String label,
    required IconData filledIcon,
    required IconData outlinedIcon,
    required bool isSelected,
    bool isFontAwesome = false,
  }) {
    Widget iconWidget;
    if (isSelected) {
      iconWidget = _buildIcon(filledIcon, isFontAwesome);
    } else {
      iconWidget = Icon(outlinedIcon, color: Colors.grey);
    }

    return BottomNavigationBarItem(icon: iconWidget, label: label);
  }

  Widget _buildIcon(IconData iconData, bool isFontAwesome) {
    Widget icon = isFontAwesome
        ? FaIcon(iconData, color: AppColors.gradientDarkStart)
        : Icon(iconData, color: AppColors.gradientDarkStart);

    return icon;
  }
}
