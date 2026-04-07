import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class BudgetTrackPage extends GetView<BudgetTrackController> {
  const BudgetTrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Budget Track",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Text("Budget Track"),
    );
  }
}
