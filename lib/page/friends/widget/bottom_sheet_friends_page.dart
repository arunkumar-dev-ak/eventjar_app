// import 'package:eventjar/global/app_colors.dart';
// import 'package:eventjar/global/responsive/responsive.dart';
// import 'package:eventjar/model/budget_track/friend_model.dart';
// import 'package:flutter/material.dart';

// class TripsBottomSheetFriendList extends StatelessWidget {
//   final FriendModel friend;

//   const TripsBottomSheetFriendList({required this.friend, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(4.wp),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // HEADER
//           Text(
//             "${friend.name}'s Trips",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
//           ),

//           SizedBox(height: 2.hp),

//           // LIST
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: 3,
//             itemBuilder: (_, i) {
//               return InkWell(
//                 onTap: () {},
//                 borderRadius: BorderRadius.circular(12),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 1.4.hp),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// 🔹 LEFT SIDE
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Goa Trip",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 10.sp,
//                                     color: Colors.black.withValues(alpha: 0.7),
//                                   ),
//                                 ),

//                                 SizedBox(height: 0.5.hp),

//                                 Row(
//                                   children: [
//                                     Text(
//                                       "Pending settlement (10)",
//                                       style: TextStyle(
//                                         fontSize: 8.5.sp,
//                                         color: Colors.grey,
//                                       ),
//                                     ),

//                                     SizedBox(width: 1.wp),

//                                     Icon(
//                                       Icons.arrow_forward_ios,
//                                       size: 12,
//                                       color: Colors.grey,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           /// 🔹 RIGHT SIDE (AMOUNT)
//                           Text(
//                             "₹500",
//                             style: TextStyle(
//                               color: Colors.red, // or dynamic
//                               fontWeight: FontWeight.w600,
//                               fontSize: 10.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     Divider(
//                       height: 1,
//                       color: Colors.black.withValues(alpha: 0.7),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),

//           SizedBox(height: 2.hp),
//         ],
//       ),
//     );
//   }
// }
