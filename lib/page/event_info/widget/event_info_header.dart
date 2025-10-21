import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventInfoHeader extends StatelessWidget {
  const EventInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.wp, horizontal: 3.wp),
      child: Column(
        children: [
          //organizer row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "Organized By",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2.wp),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8OqmaM2JMF1M-gd44wB2ZBBWxRUdqBFWjbQbdmMwI7UTOr9HL0FWuqK4liM2af2MxqMw&usqp=CAU",
                      ),
                    ),
                    SizedBox(width: 2.wp),
                    Expanded(
                      child: Text(
                        "Richard Chinnapan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.wp),
              Icon(Icons.info_outline, color: AppColors.gradientDarkStart),
            ],
          ),
          SizedBox(height: 1.hp),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: const Color.fromARGB(
                  255,
                  255,
                  109,
                  99,
                ).withValues(alpha: 0.8),
              ),
              SizedBox(width: 2.wp),
              Expanded(
                child: Text(
                  "Codissia Ground,Tamilnadu Coimbatore",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.hp),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.clock,
                color: const Color.fromARGB(255, 7, 102, 180),
                size: 20,
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Text(
                  "Oct 07, 2025 • 07:00 PM",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.hp),
          Container(
            width: 100.wp,
            height: 1,
            color: Colors.white.withAlpha(125),
          ),
          SizedBox(height: 2.hp),

          //attendes row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //attended profile
                  Row(
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 35,
                        width: 70, // height of the avatars
                        child: Stack(
                          clipBehavior: Clip.none, // allow overflow for overlap
                          children: [
                            // 3rd avatar (backmost)
                            Positioned(
                              left: 40, // shift to the right
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  "https://media.istockphoto.com/id/588258370/vector/male-avatar-profile-picture-vector.jpg?s=612x612&w=0&k=20&c=HySLtDNJEd_wzsAjchZxWstBToxkMHSI2rKHNss7CD0=",
                                ),
                              ),
                            ),

                            // 2nd avatar (middle)
                            Positioned(
                              left: 20,
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  "https://media.istockphoto.com/id/588258370/vector/male-avatar-profile-picture-vector.jpg?s=612x612&w=0&k=20&c=HySLtDNJEd_wzsAjchZxWstBToxkMHSI2rKHNss7CD0=",
                                ),
                              ),
                            ),

                            // 1st avatar (frontmost)
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                "https://media.istockphoto.com/id/588258370/vector/male-avatar-profile-picture-vector.jpg?s=612x612&w=0&k=20&c=HySLtDNJEd_wzsAjchZxWstBToxkMHSI2rKHNss7CD0=",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  generateBadge(label: "33 going"),
                ],
              ),

              //total attended
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.gradientDarkStart),
                      SizedBox(width: 1.wp),
                      Text(
                        "33/40",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.hp),
                  generateBadge(label: "34 Spots left"),
                ],
              ),

              //location row
              eventModeBadge(mode: "Virtual"),
            ],
          ),
        ],
      ),
    );
  }
}

Widget generateBadge({required String label}) {
  return Container(
    decoration: BoxDecoration(
      gradient: AppColors.buttonGradient,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.all(1.wp),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget eventModeBadge({required String mode}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.gradientDarkStart,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.grey, offset: Offset(0.5, 1), blurRadius: 1),
      ],
    ),
    child: Text(
      "Virtual",
      style: TextStyle(
        color: Colors.white,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
