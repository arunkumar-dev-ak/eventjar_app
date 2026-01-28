import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
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
      final isLoggedIn = controller.isLoggedIn.value;
      final profileData = controller.profile;
      final profileName = _getDisplayName(profileData);

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
          _createProfileTabItem(
            selectedIndex: selectedIndex == 2,
            isLoggedIn: isLoggedIn,
            profileData: profileData,
            profileName: profileName,
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
          controller.changeTab(index);
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

  BottomNavigationBarItem _createProfileTabItem({
    required bool selectedIndex,
    required bool isLoggedIn,
    required Map<String, dynamic> profileData,
    required String profileName,
  }) {
    Widget iconWidget;

    if (isLoggedIn && profileData.isNotEmpty && profileName != "User") {
      iconWidget = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedIndex
                ? AppColors.gradientDarkStart
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipOval(
          child:
              profileData['avatarUrl'] != null &&
                  profileData['avatarUrl'].toString().isNotEmpty
              ? Image.network(
                  getFileUrl(profileData['avatarUrl']),
                  fit: BoxFit.cover,
                  width: 28,
                  height: 28,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildInitialsAvatar(name: profileData['name'] ?? ''),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildInitialsAvatar(
                      name: profileData['name'] ?? '',
                    );
                  },
                )
              : _buildInitialsAvatar(name: profileData['name'] ?? ''),
        ),
      );
    } else {
      iconWidget = Icon(
        selectedIndex ? Icons.account_circle : Icons.account_circle_outlined,
        size: 24,
        color: selectedIndex ? Colors.grey.shade800 : Colors.grey.shade400,
      );
    }

    final labelText = isLoggedIn && profileName != "User"
        ? "Hi, $profileName"
        : "Account";

    return BottomNavigationBarItem(icon: iconWidget, label: labelText);
  }

  String _getDisplayName(Map<String, dynamic> profileData) {
    if (profileData.isEmpty) return "User";

    final name =
        profileData['name'] ??
        profileData['username'] ??
        profileData['email']?.split('@').first ??
        "User";

    if (name.length <= 4) return name;
    return "${name.substring(0, 4)}....";
  }

  Widget _buildInitialsAvatar({required String name}) {
    final initials = name.isNotEmpty
        ? name
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
              .substring(0, 1)
        : '?';

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}
