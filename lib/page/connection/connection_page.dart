import 'package:eventjar/controller/connection/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/connection/widget/connection_build_tabs.dart';
import 'package:eventjar/page/connection/widget/connection_list.dart';
import 'package:eventjar/page/connection/widget/connection_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionPage extends GetView<ConnectionController> {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          "Connections",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              ConnectionBuildTabs(),
              const SizedBox(height: 24),
              if (controller.state.isLoading.value)
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) => connectionShimmer(),
                  ),
                )
              else if (_isEmpty())
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.refreshConnections(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 15.hp),
                        _buildEmptyState(context),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.refreshConnections(),
                    child: ConnectionList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isEmpty() {
    final tab = controller.state.selectedTab.value;
    if (tab == 0) {
      return controller.state.sent.value?.requests.isEmpty ?? true;
    }
    return controller.state.received.value?.requests.isEmpty ?? true;
  }

  Widget _buildEmptyState(BuildContext context) {
    final isSent = controller.state.selectedTab.value == 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightBlueBg(context),
          ),
          child: Icon(
            isSent ? Icons.send_outlined : Icons.call_received_outlined,
            size: 36,
            color: AppColors.gradientDarkStart,
          ),
        ),
        SizedBox(height: 2.hp),
        Text(
          isSent ? "No Sent Requests" : "No Received Requests",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 1.hp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.wp),
          child: Text(
            isSent
                ? "You haven't sent any connection requests yet. Start networking at events!"
                : "No one has sent you a connection request yet. Attend events to get noticed!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textSecondary(context),
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: 3.hp),
        Text(
          "Pull down to refresh",
          style: TextStyle(fontSize: 8.sp, color: AppColors.textHint(context)),
        ),
      ],
    );
  }
}
