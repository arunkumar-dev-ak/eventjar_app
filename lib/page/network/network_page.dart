import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/network/coming_soon_page.dart';
import 'package:eventjar/page/network/tabs/contact_page/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkPage extends GetView<NetworkScreenController> {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabList = [
      _TabData('Contacts', Icons.person_rounded),
      _TabData('Connection', Icons.connect_without_contact_rounded),
      _TabData('Scheduler', Icons.schedule_rounded),
      _TabData('Reminders', Icons.notifications_active_rounded),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Compact tab bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: GetBuilder<NetworkScreenController>(
                builder: (ctrl) {
                  return Row(
                    children: List.generate(tabList.length, (i) {
                      final selected = ctrl.state.selectedTab.value == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => ctrl.changeTab(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 1.hp),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  tabList[i].icon,
                                  size: 18,
                                  color: Colors.white.withValues(
                                    alpha: selected ? 1.0 : 0.6,
                                  ),
                                ),
                                SizedBox(height: 0.3.hp),
                                Text(
                                  tabList[i].label,
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: selected ? 1.0 : 0.6,
                                    ),
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontSize: 7.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            // Tab body
            Expanded(
              child: GetBuilder<NetworkScreenController>(
                builder: (ctrl) {
                  switch (ctrl.state.selectedTab.value) {
                    case 0:
                      return ContactNetworkStatusCards();
                    case 1:
                      return ComingSoonWidget();
                    case 2:
                      return ComingSoonWidget();
                    case 3:
                      return ComingSoonWidget();
                    default:
                      return ComingSoonWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabData {
  final String label;
  final IconData icon;
  const _TabData(this.label, this.icon);
}
