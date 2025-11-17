import 'package:flutter/material.dart';
import 'contact_card_page_utils.dart'; // Import ContactCard and ContactStage

class ContactCardPage extends StatelessWidget {
  const ContactCardPage({super.key});

  // Dummy contact list data
  final List<Map<String, dynamic>> dummyContacts = const [
    {
      "name": "Arun Kumar",
      "email": "arunkumar@example.com",
      "phone": "+91 087653456789",
      "createdDate": "Oct 3, 2025",
      "imageUrl": "https://randomuser.me/api/portraits/men/32.jpg",
      "isInvited": true,
      "isOverdue": true,
      "stages": [
        {
          "label": "New Contact",
          "desc": "Schedule Initial Meeting",
          "color": Colors.blue,
          "reached": true,
        },
        {
          "label": "24H FollowUp",
          "desc": "Initial Followup within 24 Hrs",
          "color": Colors.cyan,
          "reached": true,
        },
        {
          "label": "7D FollowUp",
          "desc": "Weekly check-in and nurturing",
          "color": Colors.indigo,
          "reached": true,
        },
        {
          "label": "30D FollowUp",
          "desc": "Monthly relationship building",
          "color": Colors.blueAccent,
          "reached": true,
        },
        {
          "label": "Qualified Lead",
          "desc": "Confirmed qualified lead status",
          "color": Colors.green,
          "reached": true,
        },
      ],
    },
    {
      "name": "Priya Verma",
      "email": "priya.verma@example.com",
      "phone": "+91 098765432123",
      "createdDate": "Sep 24, 2025",
      "imageUrl": "https://randomuser.me/api/portraits/women/44.jpg",
      "isInvited": false,
      "isOverdue": false,
      "stages": [
        {
          "label": "New Contact",
          "desc": "Schedule Initial Meeting",
          "color": Colors.blue,
          "reached": true,
        },
        {
          "label": "24H FollowUp",
          "desc": "Initial Followup within 24 Hrs",
          "color": Colors.cyan,
          "reached": true,
        },
        {
          "label": "7D FollowUp",
          "desc": "Weekly check-in and nurturing",
          "color": Colors.indigo,
          "reached": false,
        },
        {
          "label": "30D FollowUp",
          "desc": "Monthly relationship building",
          "color": Colors.blueAccent,
          "reached": false,
        },
        {
          "label": "Qualified Lead",
          "desc": "Confirmed qualified lead status",
          "color": Colors.green,
          "reached": false,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: dummyContacts.length,
      itemBuilder: (context, index) {
        final contact = dummyContacts[index];

        // Convert map stages to ContactStage list
        List<ContactStage> stages = (contact['stages'] as List)
            .map(
              (e) => ContactStage(
                label: e['label'],
                desc: e['desc'],
                color: e['color'],
                reached: e['reached'],
              ),
            )
            .toList();

        return ContactCard(
          name: contact['name'],
          email: contact['email'],
          phone: contact['phone'],
          createdDate: contact['createdDate'],
          imageUrl: contact['imageUrl'],
          isInvited: contact['isInvited'],
          isOverdue: contact['isOverdue'],
          stages: stages,
        );
      },
    );
  }
}
