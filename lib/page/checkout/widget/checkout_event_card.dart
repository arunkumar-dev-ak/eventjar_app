import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutEventCard extends StatelessWidget {
  final dynamic eventInfo;

  const CheckoutEventCard({super.key, required this.eventInfo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventInfo.title,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.5.hp),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              SizedBox(width: 2.wp),
              Expanded(
                child: Text(
                  eventInfo.isVirtual
                      ? "Online Event"
                      : "${eventInfo.venue}, ${eventInfo.city ?? ''}",
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.hp),

          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              SizedBox(width: 2.wp),
              Expanded(
                child: Text(
                  controller.formatEventDateTimeForHome(eventInfo, context),
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
