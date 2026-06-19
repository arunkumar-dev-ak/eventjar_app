import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/empty_widget.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/page/view_trip/expense/expense_shimmer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseList extends GetView<ViewTripController> {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expenses = controller.state.expenses;
      final haveNextPage = controller.hasExpenseMore;
      final isLoading = controller.state.isLoading.value;

      if (isLoading) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return const ExpenseShimmerCard();
          },
        );
      }

      // Empty State
      if (expenses.isEmpty && !controller.state.isLoading.value) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 60.hp,
            child: EmptyStateWidget(
              icon: Icons.receipt_long,
              title: 'no_expenses_yet'.tr,
              subtitle: 'start_adding_expenses'.tr,
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: haveNextPage ? expenses.length + 1 : expenses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= expenses.length) {
            return const ExpenseShimmerCard();
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

    // ✅ Use your model's exact property here
    final isClosed = e.isDeleted;

    final card = Opacity(
      // Make the entire card slightly faded if it's closed
      opacity: isClosed ? 0.65 : 1.0,
      child: Align(
        alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            HapticHelper.light();
            controller.navigateToExpenseDetailPage(e);
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
            // Pass the isClosed state to the card content
            child: _cardContent(context, e, isYou, isClosed: isClosed),
          ),
        ),
      ),
    );

    // If it's NOT you, OR if the expense is ALREADY CLOSED (deleted), just return the card (No swipe allowed)
    if (!isYou || isClosed) return card;

    return Dismissible(
      key: ValueKey(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: 1.hp),
        padding: EdgeInsets.only(right: 5.wp),
        decoration: BoxDecoration(
          color: Colors.orange.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.cancel_presentation_rounded,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (_) async {
        HapticHelper.medium();
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _CloseExpenseDialog(
            expenseTitle: e.title,
            expenseId: e.id,
            controller: controller,
          ),
        );
        return result == true;
      },
      onDismissed: (_) {},
      child: card,
    );
  }
  // ---------------- CARD ----------------

  Widget _cardContent(
    BuildContext context,
    TripExpenseModel e,
    bool isYou, {
    bool isClosed = false,
  }) {
    final splitCount = e.count?.participants ?? e.participants.length;
    final myParticipant = _myParticipant(e);
    final currency = e.currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // Change icon color if closed
                color: isClosed ? Colors.grey : Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
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
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          e.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 9.5.sp,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ),
                      // Top label removed from here!
                    ],
                  ),
                  SizedBox(height: 0.3.hp),
                  Text(
                    "${e.currency} ${e.amount.toStringAsFixed(0)}",
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
                    'paid_by'.tr,
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
                      color: isClosed
                          ? AppColors.textSecondary(context)
                          : Theme.of(context).brightness == Brightness.dark
                          ? Colors.orange.shade300
                          : Colors.orange.shade700,
                    ),
                  ),
              ],
            ),
          ],
        ),

        SizedBox(height: 1.hp),

        Row(
          children: [
            // If closed, show the red CLOSED label badge at the bottom
            if (isClosed) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                ),
                child: Text(
                  "CLOSED",
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ]
            // If active, show the normal payment details
            else ...[
              if (isYou) ...[
                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                SizedBox(width: 1.wp),
                Text(
                  "${'paid'.tr} ${e.currency} ${e.amount.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green.shade300
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 1.5.wp),
                Text(
                  "- $splitCount ${'members'.tr}",
                  style: TextStyle(
                    fontSize: 7.5.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ] else ...[
                if (myParticipant?.isPaid == true) ...[
                  const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  SizedBox(width: 1.wp),
                  Text(
                    "${'paid'.tr} $currency ${myParticipant?.shareAmount.toStringAsFixed(0) ?? '0'}",
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.green.shade300
                          : Colors.green.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ] else ...[
                  Text(
                    "${'my_share'.tr} $currency ${myParticipant?.shareAmount.toStringAsFixed(0) ?? '0'}",
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ],
            ],

            const Spacer(),

            _buildMemberAvatars(context, splitCount),

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

  Widget _buildMemberAvatars(BuildContext context, int totalCount) {
    if (totalCount <= 0) return const SizedBox.shrink();

    const maxShow = 5;
    const double size = 22;
    const double overlap = 6;

    final showCount = totalCount > maxShow ? maxShow : totalCount;
    final extra = totalCount - maxShow;
    final totalCircles = showCount + (extra > 0 ? 1 : 0);

    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
    ];

    return SizedBox(
      height: size,
      width: totalCircles * (size - overlap) + overlap,
      child: Stack(
        children: [
          for (int i = 0; i < showCount; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardBg(context),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.person, size: 12, color: Colors.white),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: showCount * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardBg(context),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$extra',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CloseExpenseDialog extends StatelessWidget {
  final String expenseTitle;
  final String expenseId;
  final ViewTripController controller;

  const _CloseExpenseDialog({
    required this.expenseTitle,
    required this.expenseId,
    required this.controller,
  });

  Future<void> _handleCloseRequest(BuildContext context) async {
    // Await the controller method which handles the state and API call
    final success = await controller.closeExpenseRequest(expenseId);

    // Only pop the dialog if the API call was successful
    if (success && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                color: isDark
                    ? Colors.orange.shade900.withValues(alpha: 0.3)
                    : Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cancel_presentation_rounded,
                size: 32,
                color: isDark ? Colors.orange.shade300 : Colors.orange.shade600,
              ),
            ),
            SizedBox(height: 1.hp),
            Text(
              'close_request'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),
            Text(
              'Are you sure you want to close the request for "$expenseTitle"?',
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
                color: AppColors.chipBg(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textSecondary(context),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'close_request_warning'.tr,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.hp),

            // Wrap the buttons in an Obx to listen to the global loading state
            Obx(() {
              final isLoading = controller.state.deleteExpenseLoading.value;

              return Row(
                children: [
                  // Cancel Button
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
                      // Disable tap if loading
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.wp),

                  // Close/Submit Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      // Disable tap if loading
                      onPressed: isLoading
                          ? null
                          : () => _handleCloseRequest(context),
                      child: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'close'.tr,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
