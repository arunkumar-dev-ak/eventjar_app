import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Map<String, dynamic>> attendeeList = [
  {
    "name": "Richard Chinnappan",
    "number": 1,
    "role": "Founder",
    "company": "Humbletree Cloud Private Limited",
    "bio":
        "EventJar is proudly developed by Humbletree Cloud, a leading SaaS and web solutions company committed to empowering business networking and event management through smart, scalable technology.",
    "avatarUrl": null,
  },
  {
    "name": "Marbin Shamini",
    "number": 2,
    "role": "Lead Developer",
    "company": "Tech Innovators",
    "bio":
        "Expert in mobile and web technologies, passionate about delivering scalable solutions for global events.",
    "avatarUrl": null,
  },
  {
    "name": "Arunkumar S",
    "number": 3,
    "role": "Product Manager",
    "company": "MK Solutions",
    "bio":
        "Focused on product strategy and customer engagement for emerging SaaS products.",
    "avatarUrl": null,
  },
];

class ConnectionAttendeeList extends StatelessWidget {
  ConnectionAttendeeList({super.key});

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAttendeeInfoCard(attendeeList[0]),
        SizedBox(height: 1.hp),
        buildAttendeeInfoCard(attendeeList[1]),
        SizedBox(height: 1.hp),
        buildAttendeeInfoCard(attendeeList[2]),
        SizedBox(height: 1.hp),
      ],
    );
  }
}

Widget buildAttendeeInfoCard(
  Map<String, dynamic> attendee, {
  VoidCallback? onSendRequest,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 0.5.wp, horizontal: 0.5.wp),
    padding: EdgeInsets.all(1.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.10),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Avatar
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade100,
          child: attendee["avatarUrl"] != null
              ? ClipOval(
                  child: Image.network(
                    attendee["avatarUrl"],
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  attendee["name"].substring(0, 1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
        ),
        SizedBox(width: 4.wp),
        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attendee["name"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
              SizedBox(height: 0.9.hp),
              Text(
                '${attendee["role"]} at ${attendee["company"]}',
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                attendee["bio"],
                style: TextStyle(fontSize: 7.5.sp, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              // Send Meeting Request Button
              ElevatedButton(
                onPressed: onSendRequest,
                style:
                    ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 1,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) => Colors.transparent,
                      ),
                      elevation: WidgetStateProperty.resolveWith<double>(
                        (states) => 0,
                      ),
                    ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(1.wp),
                    constraints: BoxConstraints(minWidth: 88),
                    alignment: Alignment.center,
                    child: Text(
                      "Send Meeting Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 7.5.sp,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
