import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/network/tabs/contact_page/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkPage extends GetView<NetworkScreenController> {
  const NetworkPage({super.key});

  final List<_TabData> tabList = const [
    _TabData('Contacts', Icons.person),
    _TabData('Connection', Icons.connect_without_contact),
    _TabData('Scheduler', Icons.schedule),
    _TabData('Reminders', Icons.notifications_active),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(2.wp),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: GetBuilder<NetworkScreenController>(
                  builder: (ctrl) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(tabList.length, (i) {
                          final selected = ctrl.state.selectedTab.value == i;
                          return GestureDetector(
                            onTap: () => ctrl.changeTab(i),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 140),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.wp,
                                vertical: 2.hp,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (selected)
                                    Icon(
                                      tabList[i].icon,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  if (selected) SizedBox(width: 8),
                                  Text(
                                    tabList[i].label,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: selected ? 1.0 : 0.7,
                                      ),
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
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
                      return Center(child: Text('Scheduler Tab'));
                    case 2:
                      return Center(child: Text('Reminders Tab'));
                    case 3:
                      return Center(child: Text('Budget Track Tab'));
                    default:
                      return Center(child: Text(''));
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
