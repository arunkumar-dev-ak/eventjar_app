import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String name;
  final String email;
  final int amount;
  final bool isOwed;

  const BalanceCard({
    super.key,
    required this.name,
    required this.email,
    required this.amount,
    required this.isOwed,
  });

  String get initials =>
      name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Avatar
          Container(
            width: 32.sp,
            height: 32.sp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkStart.withValues(alpha: 0.7),
                  AppColors.gradientDarkEnd.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 3.wp),

          /// 🔥 LEFT CONTENT (Name + Email + Actions)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),

                SizedBox(height: 0.4.hp),

                /// Email
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),

                SizedBox(height: 0.8.hp),

                /// 🔥 ACTION BADGES
                Row(
                  children: [
                    /// 🔥 Remind (only if owed)
                    if (isOwed) ...[
                      _buildBadge(
                        icon: Icons.notifications_none,
                        label: "Remind",
                        colors: [
                          Colors.grey.withValues(alpha: 0.2),
                          Colors.grey.withValues(alpha: 0.05),
                        ],
                        textColor: Colors.black,
                        onTap: () {},
                      ),
                      SizedBox(width: 2.wp),
                    ],

                    /// 🔥 Record
                    _buildBadge(
                      icon: Icons.check_circle_outline,
                      label: "Record",
                      colors: isOwed
                          ? [
                              Colors.green.withValues(alpha: 0.2),
                              Colors.green.withValues(alpha: 0.05),
                            ]
                          : [
                              Colors.red.withValues(alpha: 0.2),
                              Colors.red.withValues(alpha: 0.05),
                            ],
                      textColor: isOwed ? Colors.green : Colors.red,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// 🔥 RIGHT (Amount only)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isOwed ? "gets" : "owes",
                style: TextStyle(
                  fontSize: 7.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),

              SizedBox(height: 0.4.hp),

              Text(
                "₹$amount",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isOwed ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 Reusable Badge Widget
  Widget _buildBadge({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.6.hp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 10.sp, color: textColor),
            SizedBox(width: 1.wp),
            Text(
              label,
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
