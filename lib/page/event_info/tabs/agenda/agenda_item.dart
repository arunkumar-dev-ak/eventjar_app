import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgendaItem extends StatelessWidget {
  final String title;
  final String timeRange;
  final String description;
  final String? speaker;
  final String? location;
  final bool isLastItem;

  const AgendaItem({
    super.key,
    required this.title,
    required this.timeRange,
    required this.description,
    this.speaker,
    this.location,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _timelineIndicator(isLastItem),
          SizedBox(width: 3.wp),
          Expanded(
            child: _agendaContent(
              context,
              title: title,
              timeRange: timeRange,
              description: description,
              speaker: speaker,
              location: location,
            ),
          ),
        ],
      ),
    );
  }
}

/*----- clock with line -----*/
Widget _timelineIndicator(bool isLastItem) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(FontAwesomeIcons.clock, color: Colors.red[200], size: 17),
      SizedBox(height: 1.hp),
      Expanded(child: Container(color: Colors.red[200], width: 1)),
    ],
  );
}

/*---- content -----*/
Widget _agendaContent(
  BuildContext context, {
  required String title,
  required String timeRange,
  required String description,
  String? speaker,
  String? location,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red[200]!),
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: EdgeInsets.all(3.wp),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.hp),

        _agendaBadge(
          icon: Icons.access_time,
          text: timeRange,
          color: Colors.orange,
        ),

        if (speaker != null && speaker.isNotEmpty) ...[
          SizedBox(height: 0.5.hp),
          _agendaBadge(icon: Icons.mic, text: speaker, color: Colors.blue),
        ],

        if (location != null && location.isNotEmpty) ...[
          SizedBox(height: 0.5.hp),
          _agendaBadge(
            icon: Icons.location_on,
            text: location,
            color: Colors.green,
          ),
        ],

        SizedBox(height: 1.hp),
        Text(
          description,
          maxLines: 100,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 9.sp,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _agendaBadge({
  required IconData icon,
  required String text,
  required MaterialColor color,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 1.hp, horizontal: 2.wp),
    decoration: BoxDecoration(
      color: color.shade50,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(icon, color: color.shade700, size: 18),
        SizedBox(width: 2.wp),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color.shade900,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
