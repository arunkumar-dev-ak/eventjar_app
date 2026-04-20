import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

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
        /// 🔥 Month
        Text(
          month,
          style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600),
        ),

        /// 🔥 Summary (Icons + Amounts)
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

class TransactionCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String date;
  final int amount;
  final bool isReceived;

  const TransactionCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.wp),
      margin: EdgeInsets.only(bottom: 1.2.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// 🔥 Avatar
          CircleAvatar(radius: 16.sp, child: Text(name[0])),

          SizedBox(width: 3.wp),

          /// 🔥 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReceived ? "Received from $name" : "Paid to $name",
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  date,
                  style: TextStyle(fontSize: 7.sp, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// 🔥 Amount (NEW STYLE)
          Text(
            isReceived ? "+₹$amount" : "₹$amount",
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.bold,
              color: isReceived ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
