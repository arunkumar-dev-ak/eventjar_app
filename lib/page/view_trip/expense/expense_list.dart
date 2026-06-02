import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/page/view_trip/expense/expense_detail_page.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseList extends GetView<ViewTripController> {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expenses = controller.state.expenses;
      final haveNextPage = controller.hasExpenseMore;

      return ListView.separated(
        controller: controller.expenseScrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: haveNextPage ? expenses.length + 1 : expenses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= expenses.length) {
            return Obx(
              () => controller.state.isPaginationLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
            );
          }

          final current = expenses[index];
          return _expenseItem(context, current, index);
        },
      );
    });
  }

  // ---------------- ITEM ----------------

  Widget _expenseItem(BuildContext context, TripExpenseModel e, int index) {
    final currentUserId = UserStore.to.profile['id'];

    final isYou = e.paidById == currentUserId;

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
      key: ValueKey(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: 1.hp),
        padding: EdgeInsets.only(right: 5.wp),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
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

  // ---------------- CARD ----------------

  Widget _cardContent(BuildContext context, TripExpenseModel e, bool isYou) {
    final splitCount = e.count?.participants ?? e.participants.length;

    final myParticipant = _myParticipant(e);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: Colors.white,
                size: 16,
              ),
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isYou)
                  Text(
                    "Paid by",
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                if (!isYou)
                  Text(
                    _paidByName(e),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                      color: Colors.orange.shade700,
                    ),
                  ),
              ],
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
                "Paid ₹${e.amount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 1.5.wp),
              Text(
                "- $splitCount members",
                style: TextStyle(
                  fontSize: 7.5.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ] else ...[
              if (myParticipant?.isPaid == true) ...[
                Icon(Icons.check_circle, size: 14, color: Colors.green),
                SizedBox(width: 1.wp),
                Text(
                  "Paid ₹${myParticipant?.shareAmount.toStringAsFixed(0) ?? '0'}",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ] else ...[
                Text(
                  "Your share ₹${myParticipant?.shareAmount.toStringAsFixed(0) ?? '0'}",
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ],

            const Spacer(),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 2.5.wp,
                vertical: 0.5.hp,
              ),
              decoration: BoxDecoration(
                color: AppColors.chipBg(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "$splitCount Members",
                style: TextStyle(fontSize: 7.5.sp, fontWeight: FontWeight.w600),
              ),
            ),

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

  // ---------------- HELPERS ----------------

  String _paidByName(TripExpenseModel e) {
    return e.paidBy?.name ?? e.paidByFriend?.invitedName ?? 'Unknown';
  }

  TripExpenseParticipant? _myParticipant(TripExpenseModel e) {
    final userId = UserStore.to.profile['id'];

    try {
      return e.participants.firstWhere((p) => p.userId == userId);
    } catch (_) {
      return null;
    }
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
