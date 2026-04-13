import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/balances/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'balance_model.dart';

class BalanceList extends GetView<BudgetTrackController> {
  const BalanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOwed = controller.state.isOwedSelected.value;

      /// 🔥 DATA (not widgets)
      final owedList = [
        BalanceModel(
          name: "Rahul Sharma",
          email: "rahul@gmail.com",
          amount: 1200,
          isOwed: true,
        ),
        BalanceModel(
          name: "Priya Singh",
          email: "priya@gmail.com",
          amount: 800,
          isOwed: true,
        ),
      ];

      final oweList = [
        BalanceModel(
          name: "Arjun Patel",
          email: "arjun@gmail.com",
          amount: 600,
          isOwed: false,
        ),
        BalanceModel(
          name: "Sneha Reddy",
          email: "sneha@gmail.com",
          amount: 400,
          isOwed: false,
        ),
      ];

      final currentList = isOwed ? owedList : oweList;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isOwed ? "Who owes you" : "Who you owe",
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 1.hp),

          ...currentList.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 1.2.hp),
              child: BalanceCard(
                name: item.name,
                email: item.email,
                amount: item.amount,
                isOwed: item.isOwed,
              ),
            ),
          ),
        ],
      );
    });
  }
}
