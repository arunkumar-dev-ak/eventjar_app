import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/home/widget/home_search_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSearchBar extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.wp, right: 5.wp, bottom: 5.wp),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                openSearchModel(context);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.search, size: 24, color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Explore events near you",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Icon(Icons.tune, size: 24, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
