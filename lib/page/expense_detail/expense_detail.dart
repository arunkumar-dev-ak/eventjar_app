import 'package:eventjar/controller/expense_detail/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/expense_detail/expense_detail_model.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExpenseDetailPage extends GetView<ExpenseDetailController> {
  const ExpenseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = UserStore.to.profile['id'];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.state.appBarTitle.value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
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
      body: Obx(() {
        final expense = controller.state.expense.value;

        if (expense == null) {
          return Center(child: Text('no_expense_data_found'.tr));
        }

        if (controller.state.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.state.hasError.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'something_went_wrong'.tr,
                  style: TextStyle(fontSize: 10.sp),
                ),
                SizedBox(height: 1.hp),
                FilledButton.icon(
                  onPressed: controller.retry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text('Try again'),
                ),
              ],
            ),
          );
        }

        final participants = controller.state.participants;
        final paidByName = _paidByName(expense);
        final myParticipant = _myParticipant(participants, currentUserId);

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: ListView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(5.wp),
            children: [
              _summaryCard(context, expense, paidByName, myParticipant),
              SizedBox(height: 3.hp),
              _sectionTitle(context, "SPLIT DETAILS"),
              SizedBox(height: 1.5.hp),
              ...participants.map(
                (p) => _splitRow(context, p, p.userId == expense.paidById),
              ),
              if (controller.state.isLoadingMore.value)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              SizedBox(height: 2.hp),
            ],
          ),
        );
      }),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    TripExpenseModel expense,
    String paidByName,
    ExpenseParticipantModel? myParticipant,
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
            "${expense.currency} ${expense.amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 0.5.hp),
          Text(
            "${'paid_by'.tr} $paidByName",
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
              "Split among ${controller.state.participants.length} people",
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
                  ? "${'you_have_paid'.tr} ${expense.currency} ${myParticipant.shareAmount.toStringAsFixed(0)}"
                  : "Your share ${expense.currency} ${myParticipant.shareAmount.toStringAsFixed(0)}",
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

  Widget _splitRow(
    BuildContext context,
    ExpenseParticipantModel participant,
    bool isPayer,
  ) {
    final name = participant.displayName;
    final avatarUrl = participant.user?.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

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
            backgroundImage: hasAvatar
                ? NetworkImage(getFileUrl(avatarUrl))
                : null,
            child: hasAvatar
                ? null
                : Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPayer ? Colors.green : Colors.grey,
                    ),
                  ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 9.5.sp,
                  ),
                ),
                if (isPayer)
                  Text(
                    'paid_by'.tr,
                    style: TextStyle(
                      fontSize: 7.5.sp,
                      color: Colors.orange.shade700,
                    ),
                  ),
              ],
            ),
          ),
          if (participant.isPaid)
            const Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 2.wp),
          Text(
            "₹${participant.shareAmount.toStringAsFixed(0)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  String _paidByName(TripExpenseModel e) {
    return e.paidBy?.name ?? e.paidByFriend?.invitedName ?? "Unknown";
  }

  ExpenseParticipantModel? _myParticipant(
    List<ExpenseParticipantModel> participants,
    String userId,
  ) {
    try {
      return participants.firstWhere((p) => p.userId == userId);
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
