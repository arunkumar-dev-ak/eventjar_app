import 'package:eventjar_app/controller/dashboard/controller.dart';
import 'package:eventjar_app/page/dashboard/widget/navigation_bar.dart';
import 'package:eventjar_app/page/home/home.dart';
import 'package:eventjar_app/page/my_ticket/my_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          return IndexedStack(
            index: controller.state.selectedIndex.value,
            children: const [
              HomePage(),
              Center(child: Text("in Network")),
              Center(child: Text("in Account")),
              MyTicketPage(),
            ],
          );
        }),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
