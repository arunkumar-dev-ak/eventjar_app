import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String createdDate;
  final String imageUrl;
  final bool isOverdue;
  final bool isInvited;
  final List<ContactStage> stages;

  const ContactCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdDate,
    required this.imageUrl,
    required this.isOverdue,
    required this.isInvited,
    required this.stages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            // Header Row: Avatar + Info + Badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(width: 16),
                // Info and badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          if (isInvited)
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                'Invite to Event jar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (isOverdue)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                'Overdue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        email,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 3),
                          Text(
                            phone,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Created: $createdDate',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Icon bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionMiniIcon(
                    icon: Icons.account_box_rounded,
                    color: Colors.grey[700],
                  ),
                  _ActionMiniIcon(
                    icon: Icons.remove_red_eye,
                    color: Colors.grey[700],
                  ),
                  _ActionMiniIcon(icon: Icons.edit, color: Colors.grey[700]),
                  _ActionMiniIcon(
                    icon: Icons.schedule,
                    color: Colors.grey[700],
                  ),
                  _ActionMiniIcon(
                    icon: Icons.timeline,
                    color: Colors.grey[700],
                  ),
                  _ActionMiniIcon(
                    icon: Icons.calendar_month,
                    color: Colors.grey[700],
                  ),
                  _ActionMiniIcon(
                    icon: Icons.delete,
                    color: Colors.red[400],
                    highlight: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Timeline
            ContactTimeline(stages: stages),
          ],
        ),
      ),
    );
  }
}

class ContactStage {
  final String label;
  final String desc;
  final Color color;
  final bool reached;

  const ContactStage({
    required this.label,
    required this.desc,
    required this.color,
    required this.reached,
  });
}

// Timeline widget for vertical progress
class ContactTimeline extends StatelessWidget {
  final List<ContactStage> stages;
  const ContactTimeline({required this.stages, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(stages.length, (i) {
        final s = stages[i];
        final isLast = i == stages.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: s.reached ? Colors.green : Colors.grey[300],
                  radius: 16,
                  child: Icon(Icons.check, color: Colors.white, size: 20),
                ),
                if (!isLast)
                  Container(width: 3, height: 40, color: Colors.red[200]),
              ],
            ),
            SizedBox(width: 16),
            // Stage Labels
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.label,
                  style: TextStyle(
                    color: s.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Container(
                  width: 170,
                  child: Text(
                    s.desc,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ),
                if (!isLast) SizedBox(height: 22),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _ActionMiniIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final bool highlight;
  const _ActionMiniIcon({
    required this.icon,
    this.color,
    this.highlight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? Colors.red[50] : Colors.grey[50],
          shape: BoxShape.circle,
          border: highlight
              ? Border.all(color: Colors.redAccent, width: 1)
              : Border.all(color: Colors.grey.shade200, width: 1),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
