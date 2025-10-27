import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverViewPage extends StatelessWidget {
  final EventInfoController controller = Get.find();

  OverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(top: 5.wp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.wp),
                    child: _buildTags(label: "free"),
                  ),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Business"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Concert"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Partnership"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Drinks"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "free"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Business"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Concert"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Partnership"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Drinks"),
                  _buildTags(label: "free"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Business"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Concert"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Partnership"),
                  SizedBox(width: 2.wp),
                  _buildTags(label: "Drinks"),
                ],
              ),
            ),
          ),
          SizedBox(height: 1.hp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.wp),
            child: Text(
              "Data structures and algorithms (DSA) go hand in hand. A data structure is not worth much if you cannot search through it or manipulate it efficiently using algorithms, and the algorithms in this tutorial are not worth much without a data structure to work on.DSA is about finding efficient ways to store and retrieve data, to perform operations on data, and to solve specific problems.By understanding DSA, you can:Decide which data structure or algorithm is best for a given situation.Make programs that run faster or use less memory.Understand how to approach complex problems and solve them in a systematic way.Where is Data Structures and Algorithms Needed. Data Structures and Algorithms (DSA) are used in virtually every software system, from operating systems to web applications:",
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
        ],
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
