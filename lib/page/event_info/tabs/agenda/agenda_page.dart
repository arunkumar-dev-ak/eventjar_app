import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/tabs/agenda/agenda_empty.dart';
import 'package:eventjar/page/event_info/tabs/agenda/agenda_header.dart';
import 'package:eventjar/page/event_info/tabs/agenda/agenda_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgendaPage extends StatelessWidget {
  final EventInfoController controller = Get.find();

  AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final eventInfo = controller.state.eventInfo.value;

      if (eventInfo == null) {
        return noAgendaFoundWidget();
      }

      // Get agenda items from the event
      final agendaItems = eventInfo.agendaItems;

      if (agendaItems.isEmpty) {
        return noAgendaFoundWidget();
      }
      String startTime = "N/A";
      String endTime = "N/A";

      if (eventInfo.startTime != null && eventInfo.startTime!.isNotEmpty) {
        startTime = controller.generateDateTimeAndFormatTime(
          eventInfo.startTime!,
          context,
        );
      }

      if (eventInfo.endTime != null && eventInfo.endTime!.isNotEmpty) {
        endTime = controller.generateDateTimeAndFormatTime(
          eventInfo.endTime!,
          context,
        );
      }

      // Format event date for header display
      final eventDate = DateFormat('MMMM d, yyyy').format(eventInfo.startDate);
      final eventTimeRange = "$startTime - $endTime";

      return Padding(
        padding: EdgeInsets.all(5.wp),
        child: Column(
          children: [
            // Header with time range and date
            AgendaHeader(
              eventTimeRange: eventTimeRange,
              eventDate: eventDate,
            ),
            SizedBox(height: 2.hp),

            // Agenda items list
            ...List.generate(agendaItems.length, (index) {
              final agendaItem = agendaItems[index];
              final isLastItem = index == agendaItems.length - 1;

              String agendaStartTime = "N/A";
              String agendaEndTime = "N/A";

              if (agendaItem['startTime'] != null &&
                  agendaItem['startTime'].isNotEmpty) {
                agendaStartTime = controller.generateDateTimeAndFormatTime(
                  eventInfo.startTime!,
                  context,
                );
              }

              if (agendaItem['endTime'] != null &&
                  agendaItem['endTime']!.isNotEmpty) {
                agendaEndTime = controller.generateDateTimeAndFormatTime(
                  eventInfo.endTime!,
                  context,
                );
              }

              return Column(
                children: [
                  AgendaItem(
                    title: agendaItem['title'] ?? 'Untitled',
                    timeRange: "$agendaStartTime - $agendaEndTime",
                    description:
                        agendaItem['description'] ??
                        'No description available',
                    speaker: agendaItem['speaker'],
                    location: agendaItem['location'],
                    isLastItem: isLastItem,
                  ),
                  if (!isLastItem) SizedBox(height: 2.hp),
                ],
              );
            }),
            SizedBox(height: 2.hp),
          ],
        ),
      );
    });
  }
}
