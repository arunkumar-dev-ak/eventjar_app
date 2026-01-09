import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/page/dashboard/widget/navigation_bar.dart';
import 'package:eventjar/page/home/home.dart';
import 'package:eventjar/page/my_ticket/my_ticket_page.dart';
import 'package:eventjar/page/network/network_page.dart';
import 'package:eventjar/page/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    //need to test the back button feature
    // return PopScope(
    //   canPop: false,
    //   onPopInvokedWithResult: (didPop, result) {
    //     if (didPop) return;

    //     if (controller.state.selectedIndex.value != 0) {
    //       // controller.changeTab(0);
    //     } else {
    //       SystemNavigator.pop();
    //     }
    //   },
    //   child: Scaffold(
    //     body: Obx(() {
    //       return IndexedStack(
    //         index: controller.state.selectedIndex.value,
    //         children: const [
    //           HomePage(),
    //           NetworkPage(),
    //           UserProfilePage(),
    //           MyTicketPage(),
    //         ],
    //       );
    //     }),
    //     bottomNavigationBar: CustomBottomNavigationBar(),
    //   ),
    // );
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.state.selectedIndex.value,
          children: const [
            HomePage(),
            NetworkPage(),
            UserProfilePage(),
            MyTicketPage(),
          ],
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
