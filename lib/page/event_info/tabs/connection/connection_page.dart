import 'package:eventjar/controller/event_info/controller.dart';

import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/contact/contact_page.dart';
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
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
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
            Obx(() {
              final count =
                  controller.state.attendeeList.value?.attendees.length ?? 0;
              return Text(
                'Attendees (${formatCount(count)})',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 8.sp,
                  color: Colors.grey.shade800,
                ),
              );
            }),
            SizedBox(height: 2.hp),

            EventInfoConnectionSearchBar(),

            SizedBox(height: 2.hp),
            ConnectionAttendeeList(),
            SizedBox(height: 2.hp),
          ],
        ),
      ),
    );
  }
}
