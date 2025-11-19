import 'package:flutter/cupertino.dart';

class ContactAnalytics {
  final int newCount;
  final int followup24h;
  final int followup7d;
  final int followup30d;
  final int qualified;
  final int overdue;
  final int total;

  ContactAnalytics({
    required this.newCount,
    required this.followup24h,
    required this.followup7d,
    required this.followup30d,
    required this.qualified,
    required this.overdue,
    required this.total,
  });

  factory ContactAnalytics.fromJson(Map<String, dynamic> json) =>
      ContactAnalytics(
        newCount: json['new'] ?? 0,
        followup24h: json['followup_24h'] ?? 0,
        followup7d: json['followup_7d'] ?? 0,
        followup30d: json['followup_30d'] ?? 0,
        qualified: json['qualified'] ?? 0,
        overdue: json['overdue'] ?? 0,
        total: json['total'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'new': newCount,
    'followup_24h': followup24h,
    'followup_7d': followup7d,
    'followup_30d': followup30d,
    'qualified': qualified,
    'overdue': overdue,
    'total': total,
  };
}

//for analytics card
class NetworkStatusCardData {
  final String label;
  final String key;
  final Color color;
  final IconData icon;

  const NetworkStatusCardData({
    required this.label,
    required this.key,
    required this.color,
    required this.icon,
  });
}
