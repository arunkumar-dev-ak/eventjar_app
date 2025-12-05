import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/page/contact/contact_card_profile/contact_card_page_profile_row.dart';
import 'package:eventjar/page/contact/contact_card_timeline/contact_card_page_timeline_accordion.dart';
import 'package:eventjar/page/contact/contact_card_timeline/contact_card_page_timeline.dart';
import 'package:flutter/material.dart';

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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row always visible
            ContactCardProfileRow(index: index, contact: contact),
            SizedBox(height: 1.hp),

            // ExpansionTile for Timeline
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(
                  horizontal: 2.wp,
                  vertical: 1.wp,
                ),
                childrenPadding: EdgeInsets.all(2.wp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.liteBlue,
                leading: buildEnhancedLeadingIconForAccordion(),
                title: buildEnhancedTitleForAccordion(contact),
                children: [ContactTimeline(contact: contact)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
