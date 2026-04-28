import 'package:eventjar/page/view_trip/expense/animated_expense_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';

class ExpenseSelectedWidget extends GetView<ViewTripController> {
  const ExpenseSelectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = controller.state.expenseSelectedIndexes.length;

      // Hide when nothing selected
      if (count == 0) return const SizedBox.shrink();

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: ExpenseAnimatedBorderCard(
          key: ValueKey(count),

          // MAIN ROW
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 1.wp),
            child: Row(
              children: [
                // SELECTED COUNT
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                    SizedBox(width: 1.wp),
                    Text(
                      "$count selected",
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                _actionIcon(
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () {
                    // TODO: settle logic
                  },
                ),

                SizedBox(width: 4.wp),

                // EDIT
                _actionIcon(
                  icon: Icons.edit,
                  onTap: () {
                    // TODO: edit logic
                  },
                ),

                SizedBox(width: 3.wp),

                // DELETE
                _actionIcon(
                  icon: Icons.delete,
                  onTap: () {
                    // TODO: delete logic
                  },
                ),

                SizedBox(width: 3.wp),

                Container(
                  padding: EdgeInsets.all(1.wp),
                  height: 20,
                  width: 1,
                  color: Colors.grey.shade300,
                ),

                SizedBox(width: 3.wp),

                // CLEAR SELECTION
                _actionIcon(
                  icon: Icons.close,
                  onTap: () {
                    controller.clearSelection();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// ================= BUTTON =================
  Widget _actionButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  /// 🔘 ICON BUTTON
  Widget _actionIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(1.wp),
        child: Icon(icon, size: 20, color: Colors.grey.shade700),
      ),
    );
  }
}
