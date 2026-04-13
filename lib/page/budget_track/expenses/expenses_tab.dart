import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/expenses/expenses_card.dart';
import 'package:flutter/material.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      children: [
        /// 🔥 Top Row
        Row(
          children: [
            /// Filter
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
              decoration: BoxDecoration(
                color: Colors.white, // 🔥 changed here
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.border(context),
                  width: 0.3.wp,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "All Trips",
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(width: 1.5.wp),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 4.5.wp,
                    color: AppColors.iconMuted(context),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// Add Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 4.5.wp, color: Colors.white),
              label: Text(
                "Add",
                style: TextStyle(fontSize: 8.5.sp, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.wp,
                  vertical: 0.8.hp,
                ),
                backgroundColor: AppColors.gradientDarkStart,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.hp),

        /// 🔥 Expense List
        ...List.generate(
          8,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 2.5.hp),
            child: const ExpenseCard(
              title: "Dinner at Cafe",
              amount: 2400,
              paidBy: "Arun",
              location: "Bali",
              splitCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}
