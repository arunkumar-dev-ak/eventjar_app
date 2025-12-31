import 'dart:ui' show ImageFilter;

import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/page/network/tabs/contact_page/contact_page_shimmer.dart';
import 'package:eventjar/page/network/tabs/contact_page/contact_page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String formatCount(int count) {
  if (count >= 100000) {
    return '${(count / 100000).toStringAsFixed(1)}L+';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(0)}k+';
  }
  return count.toString();
}

class ContactNetworkStatusCards extends StatelessWidget {
  const ContactNetworkStatusCards({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkScreenController controller = Get.find();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.wp),
      child: Obx(() {
        final isLoading = controller.state.isLoading.value;
        final analytics = controller.state.analytics.value;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 1.hp),
              ContactAnalyticsAddContactCard(),

              SizedBox(height: 1.5.hp),
              // Grid layout
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _statusCards.length - 1,
                itemBuilder: (context, index) {
                  final card = _statusCards[index];
                  if (isLoading) {
                    return ContactAnalyticsShimmer();
                  }
                  return _buildGridCard(
                    card: card,
                    count: _getCountByKey(analytics, card.key),
                    onTap: () => controller.navigateToContactPage(card),
                  );
                },
              ),

              // Full width Overdue card below grid
              SizedBox(height: 1.5.hp),
              if (isLoading) ...[
                OverdueCardShimmer(),
              ] else ...[
                ContactAnalyticsOverdueCard(
                  label: _statusCards.last.label,
                  icon: _statusCards.last.icon,
                  color: _statusCards.last.color,
                  overdueCount: _getCountByKey(
                    analytics,
                    _statusCards.last.key,
                  ),
                  onTap: () =>
                      controller.navigateToContactPage(_statusCards.last),
                ),
              ],
              SizedBox(height: 1.hp),
            ],
          ),
        );
      }),
    );
  }
}

final List<NetworkStatusCardData> _statusCards = const [
  NetworkStatusCardData(
    label: 'Total Contact',
    key: 'total',
    color: Colors.blue,
    icon: Icons.group,
  ),
  NetworkStatusCardData(
    label: 'New',
    key: 'new',
    color: Colors.cyan,
    icon: Icons.fiber_new,
  ),
  NetworkStatusCardData(
    label: '24H Followup',
    key: 'followup_24h',
    color: Colors.orange,
    icon: Icons.alarm,
  ),
  NetworkStatusCardData(
    label: '7D Followup',
    key: 'followup_7d',
    color: Colors.teal,
    icon: Icons.access_time,
  ),
  NetworkStatusCardData(
    label: '30D Followup',
    key: 'followup_30d',
    color: Colors.purple,
    icon: Icons.event_note,
  ),
  NetworkStatusCardData(
    label: 'Qualified',
    key: 'qualified',
    color: Colors.green,
    icon: Icons.thumb_up,
  ),
  NetworkStatusCardData(
    label: 'Overdue',
    key: 'overdue',
    color: Colors.red,
    icon: Icons.warning,
  ),
];

int _getCountByKey(ContactAnalytics analytics, String key) {
  switch (key) {
    case 'new':
      return analytics.newCount;
    case 'followup_24h':
      return analytics.followup24h;
    case 'followup_7d':
      return analytics.followup7d;
    case 'followup_30d':
      return analytics.followup30d;
    case 'qualified':
      return analytics.qualified;
    case 'overdue':
      return analytics.overdue;
    case 'total':
      return analytics.total;
    default:
      return 0;
  }
}

// Grid card widget
Widget _buildGridCard({
  required NetworkStatusCardData card,
  required int count,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            card.color.withValues(alpha: 0.9),
            card.color.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: card.color.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Large blurred icon in background
          Positioned(
            right: -15,
            bottom: -15,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Icon(
                card.icon,
                size: 100,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  formatCount(count),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(card.icon, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
