import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/page/contact/contact_card_page_stage_button.dart';
import 'package:flutter/material.dart';

class ContactStageModel {
  final String label;
  final ContactStage key;
  final String desc;
  final Color color;
  final bool reached;

  const ContactStageModel({
    required this.key,
    required this.label,
    required this.desc,
    required this.color,
    required this.reached,
  });
}

class ContactCardProfileTags extends StatelessWidget {
  final Contact contact;
  const ContactCardProfileTags({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        contact.isEventJarUser == true
            ? _buildBadge(
                bgColor: Colors.green[600]!,
                margin: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'On Event Jar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : _buildBadge(
                bgColor: Colors.blue[800]!,
                margin: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.info, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Not in Event Jar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

        if (contact.isOverdue)
          Container(
            margin: EdgeInsets.zero,
            width: 12, // diameter of the dot
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red[400],
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

Widget _buildBadge({
  required Color bgColor,
  required Widget child,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: child,
  );
}

class ContactTimeline extends StatelessWidget {
  final Contact contact;

  const ContactTimeline({required this.contact, super.key});

  List<ContactStageModel> generateStagesForCurrent(ContactStage current) {
    final allStages = [
      ContactStageModel(
        label: "New Contact",
        key: ContactStage.newContact,
        desc: "Schedule Initial Meeting",
        color: Colors.blue,
        reached: false,
      ),
      ContactStageModel(
        key: ContactStage.followup24h,
        label: "24H FollowUp",
        desc: "Initial Followup within 24 Hrs",
        color: Colors.cyan,
        reached: false,
      ),
      ContactStageModel(
        key: ContactStage.followup7d,
        label: "7D FollowUp",
        desc: "Weekly check-in and nurturing",
        color: Colors.indigo,
        reached: false,
      ),
      ContactStageModel(
        key: ContactStage.followup30d,
        label: "30D FollowUp",
        desc: "Monthly relationship building",
        color: Colors.blueAccent,
        reached: false,
      ),
      ContactStageModel(
        key: ContactStage.qualified,
        label: "Qualified Lead",
        desc: "Qualified lead confirmed",
        color: Colors.green,
        reached: false,
      ),
    ];

    final currentIndex = allStages.indexWhere((stage) => stage.key == current);

    for (int i = 0; i <= currentIndex; i++) {
      allStages[i] = ContactStageModel(
        label: allStages[i].label,
        key: allStages[i].key,
        desc: allStages[i].desc,
        color: allStages[i].color,
        reached: true,
      );
    }
    return allStages;
  }

  // Dart version of getNextActionForStage
  String getNextActionForStage(ContactStage stage) {
    switch (stage) {
      case ContactStage.newContact:
        return 'Schedule initial meeting with contact';
      case ContactStage.followup24h:
        return 'Send initial follow-up email within 24 hours';
      case ContactStage.followup7d:
        return 'Schedule weekly check-in call';
      case ContactStage.followup30d:
        return 'Send monthly relationship building message';
      case ContactStage.qualified:
        return 'Prepare conversion proposal';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ContactStage currentStage = contact.stage;
    final String? notes = contact.notes;
    final stages = generateStagesForCurrent(currentStage);
    final nextActionText = getNextActionForStage(currentStage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline stages
        Column(
          children: List.generate(stages.length, (i) {
            final s = stages[i];
            final isLast = i == stages.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline indicator (unchanged)
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: s.reached
                          ? Colors.green
                          : Colors.grey[300],
                      radius: 16,
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                    if (!isLast)
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 40,
                            color: Colors.red[200],
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(width: 16),
                // Label and description + Action Button
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.label,
                              style: TextStyle(
                                color: s.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 9.sp,
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: Text(
                                s.desc,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 8.sp,
                                ),
                              ),
                            ),
                            if (!isLast) SizedBox(height: 22),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.wp),
                      if (!isLast)
                        _buildConnectorWithAction(i, stages, contact),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(height: 20),
        // Next Action section
        Text(
          'Next Action:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
        ),
        SizedBox(height: 4),
        Text(
          nextActionText,
          style: TextStyle(fontSize: 9.sp, color: Colors.black87),
        ),
        SizedBox(height: 16),
        // Notes section (optional)
        if (notes != null && notes.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                unselectedWidgetColor: Colors.grey[700],
                iconTheme: const IconThemeData(
                  color: Colors.blueAccent,
                  size: 28,
                ),
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 3.wp),
                childrenPadding: EdgeInsets.symmetric(horizontal: 3.wp),
                title: Row(
                  children: [
                    const Icon(
                      Icons.note_alt_outlined,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                        color: Colors.blueAccent.shade700,
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      notes,
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

Widget _buildConnectorWithAction(
  int index,
  List<ContactStageModel> stages,
  Contact contact,
) {
  final currentStage = stages[index].key;
  final isCurrentStageReached = stages[index].reached;

  // Show action button only if current stage reached but next isn't
  if (isCurrentStageReached && !stages[index + 1].reached) {
    return ContactCardPageStageActionButton(
      currentStage: currentStage,
      contact: contact,
    );
  }

  // Default connector line
  return SizedBox(height: 22);
}
