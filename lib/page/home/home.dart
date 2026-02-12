import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/customized_upgrader/custom_upgrade_alert.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/home/widget/home_appbar.dart';
import 'package:eventjar/page/home/widget/home_content.dart';
import 'package:eventjar/page/home/widget/home_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomUpgradeAlert(
      upgrader: Upgrader(
        // messages: MyEventJarUpgradeMessages(),
        // debugLogging: true,
        durationUntilAlertAgain: const Duration(days: 2),
        // durationUntilAlertAgain: const Duration(seconds: 60),
      ),
      child: Container(
        width: 100.wp,
        decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              return controller.onTabOpen();
            },
            child: CustomScrollView(
              controller: controller.homeScrollController,
              // physics: controller.state.events.isEmpty
              //     ? const NeverScrollableScrollPhysics()
              //     : const AlwaysScrollableScrollPhysics(),
              slivers: [
                // SliverAppBar(
                //   backgroundColor: Colors.transparent,
                //   elevation: 0,
                //   expandedHeight: 8.hp,
                //   pinned: false,
                //   floating: false,
                //   flexibleSpace: FlexibleSpaceBar(background: HomeAppBar()),
                // ),
                // SliverPersistentHeader(
                //   pinned: true,
                //   delegate: _SliverSearchBarDelegate(
                //     minHeight: 70,
                //     maxHeight: 70,
                //     child: Container(
                //       decoration: const BoxDecoration(
                //         gradient: AppColors.appBarGradient,
                //       ),
                //       child: HomeSearchBar(),
                //     ),
                //   ),
                // ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverSearchBarDelegate(
                    minHeight: 70,
                    maxHeight: 70,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.appBarGradient,
                      ),
                      child: HomeAppBar(),
                    ),
                  ),
                ),
                DecoratedSliver(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(child: HomeProfile()),
                      HomeContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _SliverSearchBarDelegate({
    required this.child,
    this.minHeight = 80, // minimum height
    this.maxHeight = 80, // maximum expanded height
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(height: maxHeight, color: Colors.white, child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverSearchBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
