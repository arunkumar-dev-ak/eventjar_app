import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/page/contact/contact_card_page_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final int index;

  const ContactCard({required this.contact, required this.index, super.key});

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
            ContactCardProfileRow(index: index, contact: contact),
            SizedBox(height: 1.5.hp),

            // Icon bar
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(14),
            //     border: Border.all(color: Colors.grey.shade200),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withValues(alpha: 0.1),
            //         blurRadius: 8,
            //         offset: Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       _ActionMiniIcon(
            //         icon: Icons.account_box_rounded,
            //         color: Colors.grey[700],
            //       ),
            //       _ActionMiniIcon(
            //         icon: Icons.remove_red_eye,
            //         color: Colors.grey[700],
            //       ),
            //       _ActionMiniIcon(icon: Icons.edit, color: Colors.grey[700]),
            //       _ActionMiniIcon(
            //         icon: Icons.schedule,
            //         color: Colors.grey[700],
            //       ),
            //       _ActionMiniIcon(
            //         icon: Icons.timeline,
            //         color: Colors.grey[700],
            //       ),
            //       _ActionMiniIcon(
            //         icon: Icons.calendar_month,
            //         color: Colors.grey[700],
            //       ),
            //       _ActionMiniIcon(
            //         icon: Icons.delete,
            //         color: Colors.red[400],
            //         highlight: true,
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 1.hp),
            // Timeline
            ContactTimeline(currentStage: contact.stage, notes: contact.notes),
          ],
        ),
      ),
    );
  }
}

class ContactCardProfileRow extends StatelessWidget {
  final int index;
  final Contact contact;
  const ContactCardProfileRow({
    super.key,
    required this.index,
    required this.contact,
  });

  static final List<Color> _lightColors = [
    Colors.lightBlue.shade200,
    Colors.lightGreen.shade200,
    Colors.amber.shade500,
    Colors.pink.shade200,
    Colors.orange.shade400,
    Colors.purple.shade200,
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = _lightColors[index % _lightColors.length];
    final formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(contact.createdAt.toLocal());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        CircleAvatar(
          radius: 32,
          backgroundColor: bgColor,
          child: Icon(Icons.person, size: 32, color: Colors.white70),
        ),
        SizedBox(width: 3.wp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 0.2.hp),
                        //tags
                        ContactCardProfileTags(contact: contact),
                      ],
                    ),
                  ),

                  SizedBox(width: 2.wp),

                  Row(
                    children: [
                      _ActionMiniIcon(
                        icon: Icons.edit,
                        color: Colors.blue,
                        highlight: false,
                      ),
                      _ActionMiniIcon(
                        icon: Icons.delete,
                        color: Colors.red,
                        highlight: true,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 0.2.hp),
              Text(
                contact.email,
                style: TextStyle(color: Colors.grey[700], fontSize: 8.5.sp),
              ),
              SizedBox(height: 0.2.hp),
              Row(
                children: [
                  if (contact.phone != null && contact.phone!.isNotEmpty) ...[
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 0.5.wp),
                    Text(
                      contact.phone!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 8.5.sp,
                      ),
                    ),
                    SizedBox(width: 2.wp),
                  ],
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 1.wp),
                  Text(
                    'Created: $formattedDate',
                    style: TextStyle(color: Colors.grey[700], fontSize: 8.5.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionMiniIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final bool highlight;
  const _ActionMiniIcon({
    required this.icon,
    required this.color,
    required this.highlight,
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
