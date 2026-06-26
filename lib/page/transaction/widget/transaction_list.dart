import 'package:eventjar/controller/transaction/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/empty_widget.dart';
import 'package:eventjar/page/transaction/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryList extends GetView<TransactionController> {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.state.isLoading.value;
      final transactions = controller.state.transactions;
      final dailyTotal = controller.state.dailyTotal.value;
      final isLoadingMore = controller.state.isLoadingMore.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (transactions.isEmpty) {
        return SizedBox(
          height: 40.hp,
          child: EmptyStateWidget(
            icon: Icons.receipt_long_outlined,
            title: 'no_transactions'.tr,
            subtitle: 'no_transactions_desc'.tr,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dailyTotalHeader(context, dailyTotal),
          SizedBox(height: 1.5.hp),
          ...transactions.map(
            (tx) => TransactionCard(transaction: tx),
          ),
          if (isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.hp),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      );
    });
  }

  Widget _dailyTotalHeader(BuildContext context, dynamic dailyTotal) {
    final mutedText = AppColors.textSecondary(context);
    final mutedIcon = AppColors.iconMuted(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_upward, size: 10.sp, color: mutedIcon),
            SizedBox(width: 1.wp),
            Text(
              "${dailyTotal.paid.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 8.sp, color: mutedText),
            ),
          ],
        ),
        SizedBox(width: 3.wp),
        Row(
          children: [
            Icon(Icons.arrow_downward, size: 10.sp, color: Colors.green),
            SizedBox(width: 1.wp),
            Text(
              "+${dailyTotal.received.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
