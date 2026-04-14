import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ["All Trips", "Date", "Amount", "Payment", "Type"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((e) {
          return Padding(
            padding: EdgeInsets.only(left: 3.wp),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 0.3.wp,
                ),
              ),
              child: Row(
                children: [
                  Text(e, style: TextStyle(fontSize: 8.sp)),
                  SizedBox(width: 1.wp),
                  Icon(Icons.keyboard_arrow_down, size: 12.sp),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
