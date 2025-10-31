import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgendaHeader extends StatelessWidget {
  final String eventTimeRange;
  final String eventDate;

  const AgendaHeader({
    super.key,
    required this.eventTimeRange,
    required this.eventDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.clock,
              color: const Color.fromARGB(255, 7, 102, 180),
              size: 20,
            ),
            SizedBox(width: 2.wp),
            Text(
              eventTimeRange,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          height: 2.5.hp,
          width: 1.wp,
          decoration: BoxDecoration(gradient: AppColors.buttonGradient),
        ),
        Container(
          padding: EdgeInsets.all(1.wp),
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.white, size: 20),
              SizedBox(width: 2.wp),
              Text(
                eventDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 2.wp),
            ],
          ),
        ),
      ],
    );
  }
}
