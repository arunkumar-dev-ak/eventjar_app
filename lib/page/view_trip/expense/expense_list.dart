import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/budget_track/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExpenseList extends GetView<ViewTripController> {
  final List<ExpenseModel> expenses = dummyExpenses;

  ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedExpenses = [...expenses]
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedExpenses.length,
      itemBuilder: (context, index) {
        final current = sortedExpenses[index];

        final showHeader =
            index == 0 ||
            !_isSameDay(current.date, sortedExpenses[index - 1].date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Padding(
                padding: EdgeInsets.only(top: 1.5.hp, bottom: 0.5.hp),
                child: Text(
                  _getLabel(current.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            _expenseItem(context, current, index),
          ],
        );
      },
    );
  }

  /// ================= ITEM =================
  Widget _expenseItem(BuildContext context, ExpenseModel e, int index) {
    return Obx(() {
      final isOpen = controller.state.expenseOpenedIndex.value == index;
      final isSelected = controller.state.expenseSelectedIndexes.contains(
        index,
      );

      return GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          SystemSound.play(SystemSoundType.click);
          controller.toggleToSelect(index);
        },
        onTap: () {
          if (controller.state.expenseSelectedIndexes.isNotEmpty) {
            controller.toggleToSelect(index);
          } else {
            controller.toggleToOpen(index);
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: 1.hp),
          padding: EdgeInsets.all(4.wp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.green : AppColors.budgetTabColor,
            ),
          ),
          child: Column(
            children: [
              /// 🔹 MAIN ROW
              Row(
                children: [
                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: e.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(e.icon, color: e.color, size: 18),
                  ),

                  const SizedBox(width: 12),

                  /// TITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Paid by ${e.paidBy}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${e.amount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Your share ₹${e.yourShare.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// 🔥 EXPANDABLE PART
              if (isOpen) ...[
                SizedBox(height: 1.hp),

                /// DIVIDER
                Divider(color: Colors.grey.shade300),

                SizedBox(height: 1.hp),

                /// DETAILS CARD
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0.5.hp),
                  decoration: BoxDecoration(
                    color: AppColors.budgetTabColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.wp),
                      _row("Total Amount", "₹${e.amount}"),
                      SizedBox(height: 0.5.hp),
                      _row("Category", "Dining"),
                      SizedBox(height: 1.hp),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 3.wp),
                        child: Divider(color: Colors.grey.shade500),
                      ),

                      SizedBox(height: 1.hp),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.wp),
                        child: Text(
                          "SPLITS",
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: AppColors.budgetTabTextColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.hp),

                      /// SPLITS LIST
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (_, i) {
                            return _profileItem(i);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  /// ================= ROW =================
  Widget _row(String left, String right) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(
              color: AppColors.budgetTabTextColor,
              fontSize: 8.5.sp,
            ),
          ),
          Text(
            right,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= PROFILE =================
  Widget _profileItem(int i) {
    return Container(
      width: 60,
      margin: EdgeInsets.only(right: 3.wp, left: i == 0 ? 3.wp : 0),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 214, 214, 214),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Rahul Kumar",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// ================= DATE =================
  String _getLabel(DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) return "TODAY";
    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return "YESTERDAY";
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
