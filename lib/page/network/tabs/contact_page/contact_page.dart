import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/page/network/tabs/contact_page/contact_page_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String _formatCount(int count) {
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
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 10),
      child: Obx(() {
        final isLoading = controller.state.isLoading.value;
        final analytics = controller.state.analytics.value;
        return SingleChildScrollView(
          child: Column(
            children: [
              // Grid for all cards except "Overdue"
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    _statusCards.length - 1, // exclude last item (overdue)
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final card = _statusCards[index];
                  final count = _getCountByKey(analytics, card.key);
                  if (isLoading) {
                    return ContactAnalyticsShimmer();
                  }
                  return InkWell(
                    onTap: () => controller.navigateToContactPage(card),
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
                          Icon(card.icon, size: 17.sp, color: Colors.white),
                          SizedBox(height: 1.hp),
                          Text(
                            card.label,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatCount(count),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Full width Overdue card below grid
              SizedBox(height: 2.hp),
              if (isLoading) ...[
                OverdueCardShimmer(),
              ] else ...[
                Builder(
                  builder: (context) {
                    final overdueCard = _statusCards.last;
                    final overdueCount = _getCountByKey(
                      analytics,
                      overdueCard.key,
                    );

                    return InkWell(
                      onTap: () =>
                          controller.navigateToContactPage(overdueCard),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 110, // adjust height as needed
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              overdueCard.color.withValues(alpha: 0.7),
                              overdueCard.color.withValues(alpha: 0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: overdueCard.color.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(4, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: overdueCard.color.withValues(
                                    alpha: 0.3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 24,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      overdueCard.icon,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        overdueCard.label,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatCount(overdueCount),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
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
