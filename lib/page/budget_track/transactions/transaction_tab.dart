import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/transactions/transaction_filter.dart';
import 'package:eventjar/page/budget_track/transactions/transaction_list.dart';
import 'package:flutter/material.dart';

class TransactionTab extends StatelessWidget {
  const TransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
