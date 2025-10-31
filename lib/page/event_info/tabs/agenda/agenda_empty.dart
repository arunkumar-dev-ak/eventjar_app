import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';

Widget noAgendaFoundWidget() {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 5.hp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SVG illustration
          SvgPicture.asset(
            'assets/expressing-icons/no_event_found.svg',
            height: 25.hp,
            fit: BoxFit.contain,
          ),

          // Main title
          Text(
            "No agenda items available for this event.",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.hp),
        ],
      ),
    ),
  );
}
