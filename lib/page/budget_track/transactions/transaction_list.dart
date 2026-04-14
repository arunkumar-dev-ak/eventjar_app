import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/transactions/dummy_model.dart';
import 'package:eventjar/page/budget_track/transactions/transaction_card.dart';
import 'package:flutter/material.dart';

class TransactionHistoryList extends StatelessWidget {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 Dummy Data
    final transactions = [
      TransactionModel(
        name: "Gokul",
        subtitle: "Dinner split",
        date: "14 April",
        amount: 500,
        isReceived: false,
        month: "April",
        year: "2026",
      ),
      TransactionModel(
        name: "Arun",
        subtitle: "Taxi share",
        date: "12 April",
        amount: 300,
        isReceived: true,
        month: "April",
        year: "2026",
      ),
      TransactionModel(
        name: "Rahul",
        subtitle: "Snacks",
        date: "2 March",
        amount: 200,
        isReceived: false,
        month: "March",
        year: "2026",
      ),
    ];

    /// 🔥 Group by Year → Month
    final grouped = <String, Map<String, List<TransactionModel>>>{};

    for (var tx in transactions) {
      grouped.putIfAbsent(tx.year, () => {});
      grouped[tx.year]!.putIfAbsent(tx.month, () => []);
      grouped[tx.year]![tx.month]!.add(tx);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((yearEntry) {
        final year = yearEntry.key;
        final months = yearEntry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 YEAR HEADER
            Text(
              year,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 1.hp),

            /// 🔥 MONTHS
            ...List.generate(5, (index) {
              return Column(
                children: months.entries.map((monthEntry) {
                  final month = monthEntry.key;
                  final txList = monthEntry.value;

                  /// 🔥 SENT
                  final sent = txList
                      .where((e) => !e.isReceived)
                      .fold(0, (sum, e) => sum + e.amount);

                  /// 🔥 RECEIVED
                  final received = txList
                      .where((e) => e.isReceived)
                      .fold(0, (sum, e) => sum + e.amount);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔥 MONTH HEADER
                      buildMonthHeader(
                        month: "$month ${index + 1}", // optional differentiate
                        sent: sent,
                        received: received,
                      ),

                      SizedBox(height: 1.hp),

                      /// 🔥 TRANSACTIONS
                      ...txList.map(
                        (tx) => TransactionCard(
                          name: tx.name,
                          subtitle: tx.subtitle,
                          date: tx.date,
                          amount: tx.amount,
                          isReceived: tx.isReceived,
                        ),
                      ),

                      SizedBox(height: 1.5.hp),
                    ],
                  );
                }).toList(),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  /// 🔥 MONTH HEADER WITH ICONS
  Widget buildMonthHeader({
    required String month,
    required int sent,
    required int received,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.hp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Month
          Text(
            month,
            style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600),
          ),

          /// Summary (Icons + Amounts)
          Row(
            children: [
              /// 🔻 SENT
              Row(
                children: [
                  Icon(Icons.arrow_upward, size: 10.sp, color: Colors.grey),
                  SizedBox(width: 1.wp),
                  Text(
                    "₹$sent",
                    style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(width: 3.wp),

              /// 🔺 RECEIVED
              Row(
                children: [
                  Icon(Icons.arrow_downward, size: 10.sp, color: Colors.green),
                  SizedBox(width: 1.wp),
                  Text(
                    "+₹$received",
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
