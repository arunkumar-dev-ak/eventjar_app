import 'package:eventjar/controller/event_info/controller.dart';

import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_list.dart';
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
            ConnectionAttendeeList(),
            SizedBox(height: 2.hp),
            ConnectionAttendeesTab(),
            SizedBox(height: 2.hp),
            // connection req attendee
            ConnectionRequestAttendee(),

            SizedBox(height: 2.hp),
          ],
        ),
      ),
    );
  }
}
