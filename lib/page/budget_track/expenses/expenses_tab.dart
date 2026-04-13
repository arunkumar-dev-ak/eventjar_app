import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/expenses/expenses_card.dart';
import 'package:flutter/material.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
      children: [
        /// 🔥 Top Row (Filter + Add)
        Row(
          children: [
            /// Filter Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1.5.sp),
              decoration: BoxDecoration(
                color: AppColors.chipBg(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    "All Trips",
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 1.wp),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: AppColors.iconMuted(context),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Add Expense Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: Text("Add", style: TextStyle(fontSize: 8.5.sp)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1.5.sp),
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
            padding: EdgeInsets.only(bottom: 1.5.hp),
            child: ExpenseCard(
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
