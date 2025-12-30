import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/home/widget/home_appbar.dart';
import 'package:eventjar/page/home/widget/home_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.wp,
      decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchEvents(),
          color: AppColors.gradientDarkStart,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          child: Obx(() {
            return CustomScrollView(
              controller: controller.scrollController,
              physics: controller.state.events.isEmpty
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverSearchBarDelegate(
                    minHeight: 75,
                    maxHeight: 75,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.appBarGradient,
                      ),
                      child: HomeAppBar(),
                    ),
                  ),
                ),
                DecoratedSliver(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 2.hp),
                        // Section header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.wp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upcoming Events',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(() => Text(
                                    '${controller.state.events.length} events available',
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.grey.shade500,
                                    ),
                                  )),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      size: 16,
                                      color: AppColors.gradientDarkStart,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.gradientDarkStart,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.hp),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.grey.shade50,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      child: const SizedBox(height: 8),
                    ),
                  ),
                ),
                DecoratedSliver(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  sliver: HomeContent(),
                ),
              ],
            );
          }),
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
