// import 'package:eventjar/global/app_colors.dart';
// import 'package:eventjar/global/haptic_helper.dart';
// import 'package:eventjar/page/view_trip/expense/animated_expense_container.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:eventjar/controller/view_trip/controller.dart';
// import 'package:eventjar/global/responsive/responsive.dart';

// class ExpenseSelectedWidget extends GetView<ViewTripController> {
//   const ExpenseSelectedWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final count = controller.state.expenseSelectedIndexes.length;

//       // Hide when nothing selected
//       if (count == 0) return const SizedBox.shrink();

//       final primaryText = AppColors.textPrimary(context);
//       final mutedIcon = AppColors.iconMuted(context);
//       final dividerColor = AppColors.divider(context);

//       return AnimatedSwitcher(
//         duration: const Duration(milliseconds: 500),
//         child: ExpenseAnimatedBorderCard(
//           key: ValueKey(count),

//           // MAIN ROW
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 1.wp),
//             child: Row(
//               children: [
//                 // SELECTED COUNT
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       size: 12.sp,
//                       color: mutedIcon,
//                     ),
//                     SizedBox(width: 1.wp),
//                     Text(
//                       "$count selected",
//                       style: TextStyle(
//                         fontSize: 8.5.sp,
//                         fontWeight: FontWeight.w600,
//                         color: primaryText,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const Spacer(),

//                 _actionIcon(
//                   icon: Icons.account_balance_wallet_outlined,
//                   color: mutedIcon,
//                   onTap: () {
//                     // TODO: settle logic
//                   },
//                 ),

//                 SizedBox(width: 4.wp),

//                 // EDIT
//                 _actionIcon(
//                   icon: Icons.edit,
//                   color: mutedIcon,
//                   onTap: () {
//                     // TODO: edit logic
//                   },
//                 ),

//                 SizedBox(width: 3.wp),

//                 // DELETE
//                 _actionIcon(
//                   icon: Icons.delete,
//                   color: mutedIcon,
//                   onTap: () {
//                     // TODO: delete logic
//                   },
//                 ),

//                 SizedBox(width: 3.wp),

//                 Container(
//                   padding: EdgeInsets.all(1.wp),
//                   height: 20,
//                   width: 1,
//                   color: dividerColor,
//                 ),

//                 SizedBox(width: 3.wp),

//                 // CLEAR SELECTION
//                 // _actionIcon(
//                 //   icon: Icons.close,
//                 //   color: mutedIcon,
//                 //   onTap: () {
//                 //     controller.clearSelection();
//                 //   },
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   /// 🔘 ICON BUTTON
//   Widget _actionIcon({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: () {
//         HapticHelper.light();
//         onTap();
//       },
//       child: Padding(
//         padding: EdgeInsets.all(1.wp),
//         child: Icon(icon, size: 20, color: color),
//       ),
//     );
//   }
// }
