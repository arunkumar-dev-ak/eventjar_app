import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeContent extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100.wp,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.all(5.wp),
        child: Column(
          children: [
            //1st card
            Container(
              padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ image
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      "https://www.shutterstock.com/image-vector/thin-line-flat-design-banner-260nw-400060873.jpg",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 2.hp),

                  // Title
                  Text(
                    "Music Festival : Presented by Yours Club",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.hp),

                  // Place
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red[300]),
                      SizedBox(width: 1.wp),
                      Expanded(
                        child: Text(
                          "Music Festival : Presented by Yours Club",
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.85),
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.hp),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.blue[300]),
                      SizedBox(width: 1.wp),
                      Expanded(
                        child: Text(
                          "Oct 07, 2025 • 07:00 PM",
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.85),
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.hp),

                  //description
                  Text(
                    "Join our Monthly Global Business Networking Meetup, designed for business owners, entrepreneurs, and",
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.hp),

                  //tags
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildVirtualTags(label: "Virtual"),
                        SizedBox(width: 2.wp),
                        _buildTags(label: "Free Entry"),
                        SizedBox(width: 2.wp),
                        _buildTags(label: "Concert"),
                        SizedBox(width: 2.wp),
                        _buildTags(label: "Drink"),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.hp),

                  //Account
                  Row(
                    children: [
                      //account
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.grey),
                            SizedBox(width: 1.wp),
                            Text(
                              "Richard Chinnapan",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      //free button
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradientDarkEnd.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.wp,
                          vertical: 2.wp,
                        ),
                        child: Text(
                          "free",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.hp),
          ],
        ),
      ),
    );
  }
}

Widget _buildTags({required String label}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: AppColors.buttonGradient,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.gradientDarkStart,
          fontWeight: FontWeight.bold,
          fontSize: 8.sp,
        ),
      ),
    ),
  );
}

Widget _buildVirtualTags({required String label}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.gradientDarkStart,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gradientDarkStart,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 8.sp,
        ),
      ),
    ),
  );
}
