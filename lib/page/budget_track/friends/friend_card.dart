import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final String name;
  final String email;

  const FriendCard({super.key, required this.name, required this.email});

  String get initials =>
      name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBg(context),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 32.sp,
              height: 32.sp,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientDarkStart.withValues(alpha: 0.7),
                    AppColors.gradientDarkEnd.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.wp),

            /// Name + Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),

            /// Remove button
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
