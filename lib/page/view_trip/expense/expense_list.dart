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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _longPressHint(context),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                _expenseItem(context, current, index),
              ],
            );
          },
        ),
      ],
    );
  }

  /// ================= LONG-PRESS HINT =================
  Widget _longPressHint(BuildContext context) {
    return Obx(() {
      if (!controller.state.showLongPressHint.value) {
        return const SizedBox.shrink();
      }

      return AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Container(
          margin: EdgeInsets.only(bottom: 1.hp),
          padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
          decoration: BoxDecoration(
            color: AppColors.budgetTabColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider(context)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 12.sp,
                color: AppColors.budgetTabTextColor,
              ),
              SizedBox(width: 2.wp),
              Expanded(
                child: Text(
                  "Long-press an expense to select multiple",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.dismissLongPressHint();
                },
                child: Padding(
                  padding: EdgeInsets.all(1.wp),
                  child: Icon(
                    Icons.close,
                    size: 11.sp,
                    color: AppColors.budgetTabTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
            HapticFeedback.lightImpact();
            controller.toggleToOpen(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(top: 1.hp),
          padding: EdgeInsets.all(4.wp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Colors.green.withValues(alpha: 0.1)
                : AppColors.cardBg(context),
            border: Border.all(
              color: isSelected ? Colors.green : AppColors.budgetTabColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              /// 🔹 MAIN ROW
              Row(
                children: [
                  /// ICON
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: e.color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(e.icon, color: e.color, size: 18),
                      ),
                      if (isSelected)
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  /// TITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Paid by ${e.paidBy}",
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Your share ₹${e.yourShare.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
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
                Divider(color: AppColors.divider(context)),

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
                      _row(context, "Total Amount", "₹${e.amount}"),
                      SizedBox(height: 0.5.hp),
                      _row(context, "Category", "Dining"),
                      SizedBox(height: 1.hp),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 3.wp),
                        child: Divider(color: AppColors.divider(context)),
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
                            return _profileItem(context, i);
                          },
                        ),
                      ),

                      SizedBox(height: 1.hp),

                      Padding(
                        padding: EdgeInsets.fromLTRB(3.wp, 0, 3.wp, 3.wp),
                        child: Row(
                          children: [
                            _settleUpButton(context, e),
                            const Spacer(),
                            _iconActionButton(
                              context,
                              icon: Icons.edit_outlined,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                // TODO: edit expense
                              },
                            ),
                            SizedBox(width: 2.wp),
                            _iconActionButton(
                              context,
                              icon: Icons.delete_outline,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                // TODO: delete expense
                              },
                              isDestructive: true,
                            ),
                          ],
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

  /// ================= ICON ACTION =================
  Widget _iconActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDestructive
        ? (isDark ? const Color(0xFFE57373) : const Color(0xFF8B1E1E))
        : AppColors.textPrimary(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider(context)),
          ),
          child: Icon(icon, size: 11.sp, color: color),
        ),
      ),
    );
  }

  /// ================= SETTLE UP =================
  Widget _settleUpButton(BuildContext context, ExpenseModel e) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          HapticFeedback.mediumImpact();
          // TODO: settle up logic for this expense
        },
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradientFor(context),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.handshake_outlined,
                size: 11.sp,
                color: Colors.white,
              ),
              SizedBox(width: 2.wp),
              Text(
                "Settle Up · ₹${e.yourShare.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= ROW =================
  Widget _row(BuildContext context, String left, String right) {
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
              color: AppColors.textPrimary(context),
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= PROFILE =================
  Widget _profileItem(BuildContext context, int i) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 60,
      margin: EdgeInsets.only(right: 3.wp, left: i == 0 ? 3.wp : 0),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkCardElevated
                  : const Color.fromARGB(255, 214, 214, 214),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Rahul Kumar",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textPrimary(context),
            ),
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
