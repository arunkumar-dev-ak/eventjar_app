import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/balances/balances_tab.dart';
import 'package:eventjar/page/budget_track/expenses/expenses_tab.dart';
import 'package:eventjar/page/budget_track/friends/friends_tab.dart';
import 'package:eventjar/page/budget_track/transactions/transaction_tab.dart';
import 'package:eventjar/page/budget_track/trips/trips_tab.dart';
import 'package:eventjar/page/budget_track/widget/budget_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetTrackPage extends GetView<BudgetTrackController> {
  const BudgetTrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg(context),

        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // ── SLIVER 1: Title (collapses on scroll) ──
                Obx(() {
                  final header = controller.getHeader(
                    controller.state.selectedMainTab.value,
                  );

                  return SliverAppBar(
                    backgroundColor: AppColors.scaffoldBg(context),
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    floating: true,
                    snap: true,
                    expandedHeight: 70,
                    automaticallyImplyLeading: false,

                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textPrimary(context),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 4),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    header["title"]!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    header["subtitle"]!,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // ── SLIVER 2: Tabs (always pinned) ──
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    child: Container(
                      color: AppColors.scaffoldBg(context),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BudgetTabs(),
                    ),
                    height: 48, // match your 5.hp roughly
                  ),
                ),
              ];
            },

            // Scrollable Content
            body: TabBarView(
              controller: controller.tabController,
              children: const [
                FriendsTab(),
                TripsTab(),
                ExpensesTab(),
                BalancesTab(),
                TransactionTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _TabBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}
