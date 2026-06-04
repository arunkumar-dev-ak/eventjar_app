import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FriendCardShimmer extends StatelessWidget {
  const FriendCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.2.hp),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),

            SizedBox(width: 3.wp),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 35.wp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  SizedBox(height: 0.8.hp),

                  Container(
                    height: 10,
                    width: 50.wp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  SizedBox(height: 0.8.hp),

                  Container(
                    height: 10,
                    width: 25.wp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendListShimmer extends StatelessWidget {
  const FriendListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
      itemBuilder: (_, __) => const FriendCardShimmer(),
    );
  }
}
