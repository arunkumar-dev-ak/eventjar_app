import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/budget_track/expense_model.dart';
import 'package:eventjar/page/view_trip/expense/expense_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseList extends GetView<ViewTripController> {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expenses = controller.state.expense;
      final sortedExpenses = [...expenses]
        ..sort((a, b) => b.date.compareTo(a.date));
      return ListView.builder(
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
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.wp,
                        vertical: 0.5.hp,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.budgetTabColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getLabel(current.date),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              _expenseItem(context, current, index),
            ],
          );
        },
      );
    });
  }

  Widget _expenseItem(BuildContext context, ExpenseModel e, int index) {
    final isYou = e.paidBy == "You";

    final card = Align(
      alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          HapticHelper.light();
          Get.to(() => ExpenseDetailPage(expense: e));
        },
        child: Container(
          width: 78.wp,
          margin: EdgeInsets.only(top: 1.hp),
          padding: EdgeInsets.all(3.5.wp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(isYou ? 14 : 4),
              bottomRight: Radius.circular(isYou ? 4 : 14),
            ),
            color: isYou
                ? AppColors.gradientDarkStart.withValues(alpha: 0.08)
                : AppColors.cardBg(context),
            border: Border.all(
              color: isYou
                  ? AppColors.gradientDarkStart.withValues(alpha: 0.2)
                  : AppColors.budgetTabColor,
            ),
          ),
          child: _cardContent(context, e, isYou),
        ),
      ),
    );

    if (!isYou) return card;

    return Dismissible(
      key: ValueKey('${e.title}_${e.date.millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: 1.hp),
        padding: EdgeInsets.only(right: 5.wp),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      confirmDismiss: (_) async {
        HapticHelper.medium();
        final result = await showDialog<bool>(
          context: context,
          builder: (_) => _DeleteExpenseDialog(
            expenseTitle: e.title,
            onDelete: () => Navigator.of(context).pop(true),
          ),
        );
        return result == true;
      },
      onDismissed: (_) => controller.deleteExpense(index),
      child: card,
    );
  }

  Widget _cardContent(BuildContext context, ExpenseModel e, bool isYou) {
    final splitCount = e.yourShare > 0 ? (e.amount / e.yourShare).round() : 1;
    final paidCount = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: e.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(e.icon, color: e.color, size: 16),
            ),
            SizedBox(width: 2.5.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 9.5.sp,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 0.3.hp),
                  Text(
                    "₹${e.amount.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 30.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isYou) ...[
                    Text(
                      "Paid by",
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    Text(
                      e.paidBy,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.hp),
        Row(
          children: [
            if (isYou) ...[
              Icon(Icons.check_circle, size: 14, color: Colors.green),
              SizedBox(width: 1.wp),
              Text(
                "Paid",
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 1.wp),
              Text(
                "₹${e.yourShare.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 1.5.wp),
              Text(
                "-",
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(width: 1.5.wp),
              Text(
                "$paidCount/$splitCount",
                style: TextStyle(
                  fontSize: 7.5.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
            if (!isYou) ...[
              if (e.isYourSharePaid) ...[
                Icon(Icons.check_circle, size: 14, color: Colors.green),
                SizedBox(width: 1.wp),
                Text(
                  "Paid",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 1.wp),
                Text(
                  "₹${e.yourShare.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ] else ...[
                Text(
                  "Your share",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(width: 1.wp),
                Text(
                  "₹${e.yourShare.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ],
            const Spacer(),
            _stackedAvatars(context, e.members, splitCount),
            SizedBox(width: 1.wp),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textSecondary(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stackedAvatars(
    BuildContext context,
    List<String> members,
    int count,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.teal.shade300,
      Colors.red.shade300,
    ];
    final maxShow = 6;
    final showCount = count > maxShow ? maxShow : count;
    final remaining = count - maxShow;
    final totalCircles = showCount + (remaining > 0 ? 1 : 0);
    return SizedBox(
      width: 20.0 + (totalCircles - 1) * 10.0,
      height: 20,
      child: Stack(
        children: [
          ...List.generate(showCount, (i) {
            final initial = i < members.length
                ? members[i][0].toUpperCase()
                : "?";
            return Positioned(
              left: i * 10.0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[i % colors.length],
                  border: Border.all(
                    color: isDark ? AppColors.darkCardElevated : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: showCount * 10.0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.darkCardElevated
                      : Colors.grey.shade300,
                  border: Border.all(
                    color: isDark ? AppColors.darkCardElevated : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    "+$remaining",
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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

class _DeleteExpenseDialog extends StatelessWidget {
  final String expenseTitle;
  final VoidCallback onDelete;

  const _DeleteExpenseDialog({
    required this.expenseTitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 90.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                size: 36,
                color: Colors.red.shade500,
              ),
            ),
            SizedBox(height: 1.hp),
            Text(
              'Delete Expense',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),
            Text(
              'Are you sure you want to delete "$expenseTitle"?',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone and will permanently delete this expense.',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.hp),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chipBg(context),
                      foregroundColor: AppColors.textSecondary(context),
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.wp),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: onDelete,
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
