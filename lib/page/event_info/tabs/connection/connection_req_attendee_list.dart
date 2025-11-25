import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Map<String, dynamic>> inviteList = [
  {
    "name": "Richard Chinnappan",
    "company": "Humbletree Cloud Private Limited",
    "status": "Accepted",
    "date": "24/11/2025",
    "duration": "30 minutes",
    "message":
        "Hi Arunkumar, I'd like to schedule a one-on-one meeting with you.",
    "avatarUrl":
        "https://avatar.iran.liara.run/public/30", // add image URL if available
  },
  {
    "name": "Marbin Shamini",
    "company": "Tech Innovators",
    "status": "Pending",
    "date": "21/11/2025",
    "duration": "15 minutes",
    "message": "Let's connect for a project discussion.",
    "avatarUrl": null,
  },
  {
    "name": "Arunkumar S",
    "company": "MK Solutions",
    "status": "Declined",
    "date": "22/11/2025",
    "duration": "45 minutes",
    "message":
        "Sorry, I'm unavailable at your requested time. Let's reschedule soon.",
    "avatarUrl": null,
  },
];

class ConnectionRequestAttendee extends StatelessWidget {
  ConnectionRequestAttendee({super.key});

  final EventInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: controller.state.selectedAttendeeTab.value == 0
            ? [
                buildRequestAttendeeList(inviteList[0]),
                buildRequestAttendeeList(inviteList[1]),
              ]
            : [buildRequestAttendeeList(inviteList[1])],
      );
    });
  }
}

Widget buildRequestAttendeeList(Map<String, dynamic> data) {
  Color statusColor = getConnectionAttendeeStatusColor(data['status']);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 0.5.hp),
    padding: EdgeInsets.all(2.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
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
          child: data["avatarUrl"] != null
              ? ClipOval(
                  child: Image.network(
                    data["avatarUrl"],
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  data["name"].substring(0, 1),
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
                data["name"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
              SizedBox(height: 2),
              Text(
                data["company"],
                style: TextStyle(fontSize: 8.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 0.5.hp),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.wp,
                        vertical: 0.5.hp,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.9),
                            statusColor.withValues(alpha: 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        data["status"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 7.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Icon(Icons.calendar_today, size: 8.sp, color: Colors.grey),
                    SizedBox(width: 1.wp),
                    Text(
                      data["date"],
                      style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                    ),
                    SizedBox(width: 3.wp),
                    Icon(Icons.timer, size: 8.sp, color: Colors.grey),
                    SizedBox(width: 1.wp),
                    Text(
                      data["duration"],
                      style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 1.hp),
              Text(
                "Message:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 8.sp,
                  color: Colors.blue,
                ),
              ),
              Text(
                data["message"],
                style: TextStyle(fontSize: 8.sp, color: Colors.black87),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Color getConnectionAttendeeStatusColor(String status) {
  Color statusColor = status == "Accepted"
      ? Colors.green
      : status == "Pending"
      ? Colors.orange
      : Colors.grey;

  return statusColor;
}
