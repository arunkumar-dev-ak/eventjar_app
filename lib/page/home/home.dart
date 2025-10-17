import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/page/home/widget/home_appbar.dart';
import 'package:eventjar_app/page/home/widget/home_content.dart';
import 'package:eventjar_app/page/home/widget/home_searchbar.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppBar(),
            HomeSearchBar(),
            SizedBox(height: 1.hp),
            HomeContent(),
          ],
        ),
      ),
    );
  }
}
