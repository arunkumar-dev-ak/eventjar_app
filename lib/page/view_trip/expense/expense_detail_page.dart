// import 'package:eventjar/global/app_colors.dart';
// import 'package:eventjar/global/responsive/responsive.dart';
// import 'package:eventjar/model/view_trip/trip_expense_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ExpenseDetailPage extends StatelessWidget {
//   final TripExpenseModel expense;

//   const ExpenseDetailPage({super.key, required this.expense});

//   @override
//   Widget build(BuildContext context) {
//     final isYou = expense.paidBy == "You";
//     final members = expense.members.isNotEmpty
//         ? expense.members
//         : List.generate((expense.amount / expense.yourShare).round(), (i) {
//             if (i == 0 && isYou) return "You";
//             if (i == 0 && !isYou) return expense.paidBy;
//             return "Person ${i + 1}";
//           });
//     final splitCount = members.length;
//     final perPerson = expense.yourShare;

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg(context),
//       appBar: AppBar(
//         title: Text(
//           expense.title,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//         ),
//         centerTitle: false,
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Colors.transparent,
//           statusBarIconBrightness: Brightness.light,
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: AppColors.appBarGradientFor(context),
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(5.wp),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _summaryCard(context, isYou, splitCount),
//             SizedBox(height: 3.hp),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _sectionTitle(context, "SPLIT DETAILS"),
//                 if (isYou)
//                   OutlinedButton.icon(
//                     onPressed: () => _showReminderConfirm(context),
//                     icon: Icon(
//                       Icons.notifications_active_outlined,
//                       size: 14,
//                       color: Colors.orange.shade700,
//                     ),
//                     label: Text(
//                       "Reminder",
//                       style: TextStyle(
//                         fontSize: 8.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.orange.shade700,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Colors.orange.shade300),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 3.wp,
//                         vertical: 0.5.hp,
//                       ),
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 1.5.hp),
//             ...List.generate(splitCount, (i) {
//               final name = members[i];
//               final isPayer =
//                   name == expense.paidBy || (isYou && name == "You");
//               return _splitRow(context, name, perPerson, isPayer);
//             }),
//             SizedBox(height: 3.hp),
//             _totalRow(context, splitCount, perPerson),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryCard(BuildContext context, bool isYou, int splitCount) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(5.wp),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.divider(context)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: expense.color.withValues(alpha: 0.12),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(expense.icon, color: expense.color, size: 32),
//           ),
//           SizedBox(height: 2.hp),
//           Text(
//             "₹${expense.amount.toStringAsFixed(0)}",
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w800,
//               color: AppColors.textPrimary(context),
//             ),
//           ),
//           SizedBox(height: 0.5.hp),
//           Text(
//             "Paid by ${expense.paidBy}",
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: isYou
//                   ? AppColors.gradientDarkStart
//                   : Colors.orange.shade700,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 1.hp),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
//             decoration: BoxDecoration(
//               color: AppColors.budgetTabColor,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               "Split equally among $splitCount people",
//               style: TextStyle(
//                 fontSize: 8.sp,
//                 color: AppColors.textSecondary(context),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sectionTitle(BuildContext context, String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 8.5.sp,
//         fontWeight: FontWeight.w700,
//         color: AppColors.textSecondary(context),
//         letterSpacing: 1,
//       ),
//     );
//   }

//   Widget _splitRow(
//     BuildContext context,
//     String name,
//     double share,
//     bool isPayer,
//   ) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: EdgeInsets.only(bottom: 1.hp),
//       padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.divider(context)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isPayer
//                   ? AppColors.gradientDarkStart.withValues(alpha: 0.15)
//                   : (isDark
//                         ? AppColors.darkCardElevated
//                         : Colors.grey.shade200),
//             ),
//             child: Center(
//               child: Text(
//                 name[0].toUpperCase(),
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 10.sp,
//                   color: isPayer
//                       ? AppColors.gradientDarkStart
//                       : AppColors.textSecondary(context),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 3.wp),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 9.5.sp,
//                     color: AppColors.textPrimary(context),
//                   ),
//                 ),
//                 if (isPayer)
//                   Text(
//                     "Paid the bill",
//                     style: TextStyle(
//                       fontSize: 7.5.sp,
//                       color: AppColors.gradientDarkStart,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           if (isPayer)
//             Padding(
//               padding: EdgeInsets.only(right: 2.wp),
//               child: Icon(Icons.check_circle, color: Colors.green, size: 18),
//             ),
//           Text(
//             "₹${share.toStringAsFixed(0)}",
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 10.sp,
//               color: AppColors.textPrimary(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _totalRow(BuildContext context, int splitCount, double perPerson) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
//       decoration: BoxDecoration(
//         gradient: AppColors.buttonGradientFor(context),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Total ($splitCount people)",
//             style: TextStyle(
//               fontSize: 10.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             "₹${expense.amount.toStringAsFixed(0)}",
//             style: TextStyle(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showReminderConfirm(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: AppColors.cardBg(context),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade50,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.notifications_active_outlined,
//                   size: 36,
//                   color: Colors.orange.shade600,
//                 ),
//               ),
//               SizedBox(height: 1.hp),
//               Text(
//                 'Send Reminder',
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary(context),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 1.hp),
//               Text(
//                 'Send a payment reminder to all unpaid members for "${expense.title}"?',
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   color: AppColors.textSecondary(context),
//                   height: 1.4,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 3.hp),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.chipBg(context),
//                         foregroundColor: AppColors.textSecondary(context),
//                         padding: EdgeInsets.symmetric(vertical: 1.5.hp),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 9.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 2.wp),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange.shade600,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(vertical: 1.5.hp),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Reminder sent to unpaid members'),
//                             behavior: SnackBarBehavior.floating,
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Send',
//                         style: TextStyle(
//                           fontSize: 9.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
