import 'package:eventjar/controller/transaction/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/transaction/widget/transaction_filter.dart';
import 'package:eventjar/page/transaction/widget/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPage extends GetView<TransactionController> {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Transaction",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
      ),

      /// BODY
      body: ListView(
        children: [
          SizedBox(height: 1.5.hp),

          /// 🔥 FILTERS
          const TransactionFilterBar(),

          SizedBox(height: 2.hp),

          /// 🔥 HISTORY LIST
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
            child: const TransactionHistoryList(),
          ),
        ],
      ),
    );
  }
}
