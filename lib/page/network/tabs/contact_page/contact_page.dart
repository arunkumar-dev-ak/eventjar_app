import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactNetworkStatusCards extends StatelessWidget {
  final NetworkScreenController controller = Get.find();

  ContactNetworkStatusCards({super.key});

  final List<_NetworkStatusCardData> _statusCards = const [
    _NetworkStatusCardData(
      'Total Contact',
      10500,
      Colors.blue,
      Icons.group,
      "total",
    ),
    _NetworkStatusCardData(
      '24H Followup',
      1200,
      Colors.orange,
      Icons.timer_3,
      "24h",
    ),
    _NetworkStatusCardData(
      '7D Followup',
      2400,
      Colors.teal,
      Icons.access_time,
      "7d",
    ),
    _NetworkStatusCardData(
      '30D Followup',
      5000,
      Colors.purple,
      Icons.event_note,
      '30d',
    ),
    _NetworkStatusCardData(
      'Qualified',
      3000,
      Colors.green,
      Icons.thumb_up,
      'qualified',
    ),
    _NetworkStatusCardData(
      'Overdue',
      500,
      Colors.red,
      Icons.warning,
      "overdue",
    ),
  ];

  String _formatCount(int count) {
    if (count >= 100000) {
      return '${(count / 100000).toStringAsFixed(1)}L+';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}k+';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _statusCards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final card = _statusCards[index];
          return InkWell(
            onTap: () {
              controller.navigateToContactPage(card);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
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
                    color: card.color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(3, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(card.icon, size: 28, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    card.label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatCount(card.count),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NetworkStatusCardData {
  final String label;
  final String key;
  final int count;
  final Color color;
  final IconData icon;

  const _NetworkStatusCardData(
    this.label,
    this.count,
    this.color,
    this.icon,
    this.key,
  );
}
