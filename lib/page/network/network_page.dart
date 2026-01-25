import 'dart:ui';

import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/network/widget/network_header.dart';
import 'package:eventjar/page/network/widget/network_navigation_card.dart';
import 'package:eventjar/page/network/widget/network_overdue.dart';
import 'package:eventjar/page/network/widget/network_shimmer.dart';
import 'package:eventjar/page/network/widget/network_status_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkPage extends GetView<NetworkScreenController> {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        width: 100.wp,
        color: AppColors.liteBlue.withValues(alpha: 0.3),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.wp),
            child: Column(
              children: [
                SizedBox(height: 2.hp),

                NetworkHeader(),

                Expanded(
                  child: Obx(() {
                    final isLoading = controller.state.isLoading.value;
                    final analytics = controller.state.analytics.value;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.hp),

                          /// -------- STATUS GRID (TOP) ----------
                          if (isLoading)
                            networkStatusCardShimmer(crossAxisCount: 3)
                          else
                            NetworkStatusGrid(
                              analytics: analytics,
                              startIndex: 0,
                              crossAxisCount: 3,
                            ),

                          SizedBox(height: 1.5.hp),

                          /// -------- STATUS GRID (BOTTOM) ----------
                          if (isLoading)
                            networkStatusCardShimmer(crossAxisCount: 3)
                          else
                            NetworkStatusGrid(
                              analytics: analytics,
                              startIndex: 3,
                              crossAxisCount: 3,
                            ),

                          SizedBox(height: 2.hp),

                          /// -------- OVERDUE CARD ----------
                          if (isLoading)
                            const NetworkOverdueShimmer()
                          else
                            NetworkOverdueWrapper(
                              child: NetworkOverdueCard(
                                data: controller.statusCards.last,
                                count: controller.getCountByKey(
                                  analytics,
                                  controller.statusCards.last.key,
                                ),
                                onTap: () => controller.navigateToContactPage(
                                  controller.statusCards.last,
                                ),
                              ),
                            ),

                          SizedBox(height: 4.hp),

                          /// -------- ACTIONS ----------
                          Text(
                            "Actions",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(height: 1.hp),

                          NetworkNavigationCard(
                            icon: Icons.link,
                            label: "Connections",
                            onTap: controller.onConnectionTap,
                          ),
                          SizedBox(height: 0.8.hp),

                          NetworkNavigationCard(
                            icon: Icons.schedule_rounded,
                            label: "Scheduler",
                            onTap: () {
                              controller.onSchedulerTap();
                            },
                          ),

                          SizedBox(height: 0.8.hp),

                          NetworkNavigationCard(
                            icon: Icons.notifications,
                            label: "Reminders",
                            // onTap: () {},
                          ),

                          SizedBox(height: 3.hp),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
