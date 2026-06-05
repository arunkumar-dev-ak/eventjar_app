import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseDetailPage extends StatelessWidget {
  final TripExpenseModel expense;

  const ExpenseDetailPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final currentUserId = UserStore.to.profile['id'];
    final isYou = expense.paidById == currentUserId;

    final splitCount =
        expense.count?.participants ?? expense.participants.length;

    final myParticipant = _myParticipant(expense, currentUserId);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          expense.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.wp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryCard(context, isYou, splitCount, myParticipant),
            SizedBox(height: 3.hp),

            _sectionTitle(context, "SPLIT DETAILS"),
            SizedBox(height: 1.5.hp),

            ...expense.participants.map(
              (p) => _splitRow(
                context,
                p.userId,
                p.shareAmount,
                p.isPaid,
                p.userId == expense.paidById,
              ),
            ),

            SizedBox(height: 3.hp),
            _totalRow(context, splitCount),
          ],
        ),
      ),
    );
  }

  // ---------------- SUMMARY ----------------

  Widget _summaryCard(
    BuildContext context,
    bool isYou,
    int splitCount,
    TripExpenseParticipant? myParticipant,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        children: [
          const Icon(Icons.receipt_long_rounded, size: 40, color: Colors.blue),

          SizedBox(height: 2.hp),

          Text(
            "₹${expense.amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),

          SizedBox(height: 0.5.hp),

          Text(
            "Paid by ${_paidByName(expense)}",
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.hp),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
            decoration: BoxDecoration(
              color: AppColors.budgetTabColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Split among $splitCount people",
              style: TextStyle(
                fontSize: 8.sp,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),

          if (myParticipant != null) ...[
            SizedBox(height: 1.5.hp),
            Text(
              myParticipant.isPaid
                  ? "You have paid ₹${myParticipant.shareAmount.toStringAsFixed(0)}"
                  : "Your share ₹${myParticipant.shareAmount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: myParticipant.isPaid
                    ? Colors.green
                    : AppColors.textPrimary(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------- SPLIT ROW ----------------

  Widget _splitRow(
    BuildContext context,
    String userId,
    double share,
    bool isPaid,
    bool isPayer,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.hp),
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPayer
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.grey.shade300,
            child: Text(
              userId.isNotEmpty ? userId[0].toUpperCase() : "?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPayer ? Colors.green : Colors.grey,
              ),
            ),
          ),

          SizedBox(width: 3.wp),

          Expanded(
            child: Text(
              userId,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9.5.sp),
            ),
          ),

          if (isPaid) Icon(Icons.check_circle, color: Colors.green, size: 18),

          SizedBox(width: 2.wp),

          Text(
            "₹${share.toStringAsFixed(0)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  // ---------------- TOTAL ----------------

  Widget _totalRow(BuildContext context, int splitCount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradientFor(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total ($splitCount people)",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            "₹${expense.amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  String _paidByName(TripExpenseModel e) {
    return e.paidBy?.name ?? e.paidByFriend?.invitedName ?? "Unknown";
  }

  TripExpenseParticipant? _myParticipant(TripExpenseModel e, String userId) {
    try {
      return e.participants.firstWhere((p) => p.userId == userId);
    } catch (_) {
      return null;
    }
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary(context),
        letterSpacing: 1,
      ),
    );
  }
}
