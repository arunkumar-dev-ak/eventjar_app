import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/date_utils.dart';
import 'package:eventjar/model/transaction/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/global/store/user_store.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final primaryText = AppColors.textPrimary(context);
    final mutedText = AppColors.textSecondary(context);
    final currentUserId = UserStore.to.profile['id'];

    final isReceived = transaction.toUserId == currentUserId;
    final otherName = isReceived ? transaction.fromName : transaction.toName;
    final displayName = otherName.isNotEmpty ? otherName : 'unknown'.tr;

    final (date, time, _) = formatUtcToLocal(transaction.createdAt, context);

    return Container(
      padding: EdgeInsets.all(3.wp),
      margin: EdgeInsets.only(bottom: 1.2.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.sp,
            child: Text(displayName[0].toUpperCase()),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReceived
                      ? "${"received_from".tr} $displayName"
                      : "${"paid_to".tr} $displayName",
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  transaction.trip.name,
                  style: TextStyle(fontSize: 8.sp, color: mutedText),
                ),
                SizedBox(height: 0.3.hp),
                Text(
                  '$date • $time',
                  style: TextStyle(fontSize: 7.sp, color: mutedText),
                ),
              ],
            ),
          ),
          Text(
            isReceived
                ? "+${transaction.currency} ${transaction.amount.toStringAsFixed(2)}"
                : "${transaction.currency} ${transaction.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.bold,
              color: isReceived ? Colors.green : primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
