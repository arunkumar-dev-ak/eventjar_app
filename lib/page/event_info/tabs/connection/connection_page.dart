import 'package:eventjar/controller/event_info/controller.dart';

import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_list.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_page_search_bar.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_req_attendee_list.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoConnectionTab extends StatelessWidget {
  final EventInfoController controller = Get.find();

  EventInfoConnectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Dummy Data
      final attendees = [
        {
          'id': '63350f36-fbcf-4b84-ac97-25785dda140f',
          'name': 'Marbin Shamini',
          'company': null,
        },
        {
          'id': '2a86f813-fc1f-4d18-b325-116ad855b499',
          'name': 'Radhakrishnan N',
          'company': null,
        },
        {
          'id': '66d2a629-3915-4732-b7cf-b7d4076040ed',
          'name': 'Ruban',
          'company': null,
        },
        {
          'id': 'ca3b9bdd-ad3b-464d-b063-19d4105bbfd2',
          'name': 'Arunkumar',
          'company': 'MK Solutions',
        },
        {
          'id': 'c7530ffb-48e3-4020-a644-6cd280e92dc7',
          'name': 'Vetriselvan Natarajan',
          'company': null,
        },
      ];

      return GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(4.wp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConnectionAttendeesTab(),
                SizedBox(height: 2.hp),
                // connection req attendee
                ConnectionRequestAttendee(),

                SizedBox(height: 2.hp),

                //attendee
                Text(
                  'Attendees (${attendees.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.hp),

                EventInfoConnectionSearchBar(),

                SizedBox(height: 2.hp),
                ConnectionAttendeeList(),
                SizedBox(height: 2.hp),
              ],
            ),
          ),
        ),
      );
    });
  }
}
