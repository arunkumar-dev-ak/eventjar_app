import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/page/contact/contact_card_profile/contact_card_popup.dart';
import 'package:eventjar/page/contact/contact_card_profile/contact_card_profile_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final List<Color> _lightColors = [
  Colors.lightBlue.shade200,
  Colors.lightGreen.shade200,
  Colors.amber.shade500,
  Colors.pink.shade200,
  Colors.orange.shade400,
  Colors.purple.shade200,
];

enum ContactAction { edit, delete }

class ContactCardProfileRow extends StatelessWidget {
  final ContactController controller = Get.find();

  final int index;
  final Contact contact;
  ContactCardProfileRow({
    super.key,
    required this.index,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = _lightColors[index % _lightColors.length];
    final formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(contact.createdAt.toLocal());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Avatar + Name + Stage Badge + Actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              padding: EdgeInsets.all(3), // border thickness
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: contact.isOverdue
                    ? Border.all(color: Colors.red, width: 2)
                    : Border.all(color: bgColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: bgColor,
                child: Icon(Icons.person, size: 32, color: Colors.white70),
              ),
            ),

            SizedBox(width: 3.wp),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Stage Badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          contact.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.wp),
                      // Current Stage Badge
                      _buildStageBadge(contact.stage, contact.isOverdue),
                    ],
                  ),
                  SizedBox(height: 0.5.hp),
                  // Tag
                  ContactCardProfileTags(contact: contact),
                  SizedBox(height: 0.5.hp),
                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 1.wp),
                      Text(
                        contact.email,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 8.5.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            PopupMenuButton<ContactAction>(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: ContactAction.edit,
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Edit Contact',
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: ContactAction.delete,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Delete Contact',
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (action) =>
                  _handleAction(context, action, contact, controller),
            ),
          ],
        ),

        // SizedBox(height: 1.hp),

        // Bottom Row: Email + Phone + Created Date
        // Row(
        //   children: [
        //     Expanded(
        //       child: Text(
        //         contact.email,
        //         style: TextStyle(color: Colors.grey[700], fontSize: 8.5.sp),
        //       ),
        //     ),
        //     if (contact.phone != null && contact.phone!.isNotEmpty) ...[
        //       SizedBox(width: 2.wp),
        //       Icon(Icons.phone, size: 14, color: Colors.grey[600]),
        //       SizedBox(width: 0.5.wp),
        //       Text(
        //         contact.phone!,
        //         style: TextStyle(color: Colors.grey[700], fontSize: 8.5.sp),
        //       ),
        //     ],
        //     SizedBox(width: 2.wp),
        //     Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
        //     SizedBox(width: 1.wp),
        //     Text(
        //       'Created: $formattedDate',
        //       style: TextStyle(color: Colors.grey[700], fontSize: 8.5.sp),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

// NEW: Stage Badge Widget
Widget _buildStageBadge(ContactStage stage, bool isOverDue) {
  final stageInfo = _getStageInfo(stage);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.3.hp),
    decoration: BoxDecoration(
      color: isOverDue
          ? Colors.redAccent.withValues(alpha: 0.15)
          : stageInfo.color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isOverDue
            ? Colors.redAccent
            : stageInfo.color.withValues(alpha: 0.4),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          stageInfo.icon,
          size: 12,
          color: isOverDue ? Colors.redAccent : stageInfo.color,
        ),
        SizedBox(width: 0.5.wp),
        Text(
          stageInfo.label,
          style: TextStyle(
            fontSize: 7.5.sp,
            fontWeight: FontWeight.w600,
            color: isOverDue ? Colors.redAccent : stageInfo.color,
          ),
        ),
      ],
    ),
  );
}

// Stage configuration
Map<ContactStage, _StageInfo> _stageInfoMap = {
  ContactStage.newContact: _StageInfo(
    label: 'New',
    color: Colors.blue,
    icon: Icons.add_circle_outline,
  ),
  ContactStage.followup24h: _StageInfo(
    label: '24H',
    color: Colors.cyan,
    icon: Icons.schedule,
  ),
  ContactStage.followup7d: _StageInfo(
    label: '7D',
    color: Colors.indigo,
    icon: Icons.schedule,
  ),
  ContactStage.followup30d: _StageInfo(
    label: '30D',
    color: Colors.blueAccent,
    icon: Icons.update,
  ),
  ContactStage.qualified: _StageInfo(
    label: 'Qualified',
    color: Colors.green,
    icon: Icons.verified,
  ),
};

_StageInfo _getStageInfo(ContactStage stage) {
  return _stageInfoMap[stage] ??
      _StageInfo(label: 'Unknown', color: Colors.grey, icon: Icons.help);
}

class _StageInfo {
  final String label;
  final Color color;
  final IconData icon;

  _StageInfo({required this.label, required this.color, required this.icon});
}

// Action handler
void _handleAction(
  BuildContext context,
  ContactAction action,
  Contact contact,
  ContactController controller,
) {
  if (action == ContactAction.edit) {
    controller.navigateToUpdateContact(contact);
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContactCardDeletePopup(
        contactName: contact.name,
        onDelete: () => controller.deleteContactCard(contact.id),
      ),
    );
  }
}
