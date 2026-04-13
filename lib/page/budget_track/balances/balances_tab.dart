import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/balances/balance_card.dart';
import 'package:eventjar/page/budget_track/balances/balance_list.dart';
import 'package:eventjar/page/budget_track/balances/balance_summary.dart';
import 'package:flutter/material.dart';

class BalancesTab extends StatelessWidget {
  const BalancesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
      children: [
        /// 🔥 TOP SUMMARY
        const BalanceSummaryCard(),

        SizedBox(height: 2.hp),

        const BalanceList(),
      ],
    );
  }
}
