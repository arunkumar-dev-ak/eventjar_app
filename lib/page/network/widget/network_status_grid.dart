import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkStatusGrid extends GetView<NetworkScreenController> {
  final ContactAnalytics? analytics;
  final int startIndex;
  final int crossAxisCount;

  const NetworkStatusGrid({
    super.key,
    required this.analytics,
    required this.startIndex,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: crossAxisCount,
      itemBuilder: (_, index) {
        final cardIndex = startIndex + index;

        /// Safety guard
        if (cardIndex >= controller.statusCards.length - 1) {
          return const SizedBox.shrink();
        }

        final card = controller.statusCards[cardIndex];

        return NetworkStatusCard(
          data: card,
          count: controller.getCountByKey(analytics, card.key),
          onTap: () => controller.navigateToContactPage(card),
        );
      },
    );
  }
}

class NetworkStatusCard extends StatelessWidget {
  final NetworkStatusCardData data;
  final int count;
  final VoidCallback? onTap;

  const NetworkStatusCard({
    super.key,
    required this.data,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              data.color.withValues(alpha: 0.8),
              data.color.withValues(alpha: 0.45),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: data.color.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, color: Colors.white, size: 22),
            const Spacer(),
            Text(
              data.label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
