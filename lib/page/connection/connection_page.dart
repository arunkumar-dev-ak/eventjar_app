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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Connections",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
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
              else if ((controller.state.sent.value?.requests.isEmpty ??
                      true) &&
                  (controller.state.received.value?.requests.isEmpty ?? true))
                const Expanded(
                  child: Center(
                    child: Text(
                      'No connections yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                // Cards List
                Expanded(child: ConnectionList()),
            ],
          ),
        ),
      ),
    );
  }
}
