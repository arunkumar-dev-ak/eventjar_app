import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InactiveTripCard extends StatelessWidget {
  final int index;
  final TripModel trip;

  const InactiveTripCard({super.key, required this.index, required this.trip});

  String get illustrationPath {
    final imageIndex = (index % 5) + 1;
    return "assets/illustration/ill$imageIndex.svg";
  }

  /// Format amount (1L+, 10K+, etc.)
  String formatAmount(double amount) {
    if (amount >= 100000) return "${(amount / 100000).toStringAsFixed(1)}L+";
    // if (amount >= 1000) return "${(amount / 1000).toStringAsFixed(1)}K+";
    return amount.toString();
  }

  String formatTimeAgo(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();

    final diff = now.difference(date);

    if (diff.inDays >= 365) {
      return "${(diff.inDays / 365).floor()}y ago";
    } else if (diff.inDays >= 30) {
      return "${(diff.inDays / 30).floor()}mo ago";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays}d ago";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours}h ago";
    } else {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    final youOwe = trip.youOwe;
    final youGet = trip.youGet;

    final individualSpent = trip.individualSpent ?? 0;

    final pending = trip.pendingSettlements ?? 0;
    final lastActivityDate = trip.lastActivityDate;

    /// STATUS
    String statusText;
    Color statusColor;

    if (youGet > 0) {
      statusText = "RECEIVE";
      statusColor = Colors.green;
    } else if (youOwe > 0) {
      statusText = "YOU OWE";
      statusColor = Colors.red;
    } else {
      statusText = "SPENT";
      statusColor = Colors.blueGrey;
    }

    /// RIGHT SIDE BIG AMOUNT
    final mainAmount = youGet > 0
        ? youGet
        : youOwe > 0
        ? youOwe
        : individualSpent;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
      padding: EdgeInsets.all(2.5.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 6.sp,
            offset: Offset(0, 3.sp),
          ),
        ],
      ),
      child: Column(
        children: [
          /// TOP ROW
          Row(
            children: [
              /// LEFT IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(10.sp),
                child: SizedBox(
                  width: 14.wp,
                  height: 14.wp,
                  child: ColoredBox(
                    color: AppColors.lightBlueBg(context),
                    child: SvgPicture.asset(
                      illustrationPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.wp),

              /// MIDDLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: 0.4.hp),
                    Text(
                      "${trip.expenses} expenses • ${trip.members} members",
                      style: TextStyle(
                        fontSize: 7.5.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.wp),

              /// RIGHT
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${formatAmount(mainAmount)}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: 0.3.hp),
                  Text(
                    statusText,
                    style: TextStyle(fontSize: 7.sp, color: statusColor),
                  ),
                ],
              ),
            ],
          ),

          // meta
          SizedBox(height: 1.5.hp),

          Row(
            children: [
              /// Pending settlements
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.2.wp,
                  vertical: 0.5.hp,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueBg(context),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Text(
                  "Pending Settlement : $pending",
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF5B9BEF)
                        : AppColors.gradientDarkStart,
                  ),
                ),
              ),

              SizedBox(width: 4.wp),

              /// Last activity
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.2.wp,
                  vertical: 0.5.hp,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chipBg(context),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Text(
                  "Last activity ${formatTimeAgo(lastActivityDate!)}",
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: AppColors.textSecondary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
