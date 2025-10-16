import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void openSearchModel(BuildContext context) {
  final HomeController controller = Get.find();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel", style: TextStyle(fontSize: 11.sp)),
                  ),
                  Text("Search Event", style: TextStyle(fontSize: 11.sp)),
                  TextButton(
                    onPressed: () {},
                    child: Text("Search", style: TextStyle(fontSize: 11.sp)),
                  ),
                ],
              ),
              SizedBox(height: 1.hp),
              homeSearchModel(controller),
              SizedBox(height: 1.hp),
              homeSearchContent(controller),
            ],
          ),
        ),
      );
    },
  );
}

Widget homeSearchModel(HomeController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.wp),
    child: Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Obx(() {
        return Row(
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
              child: TextField(
                controller: controller.searchBarController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing to search',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
                onChanged: (val) => {controller.handleSearchOnChnage(val)},
              ),
            ),
            if (!controller.state.isSearchEmpty.value) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(85),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.clear, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    ),
  );
}

Widget homeSearchContent(HomeController controller) {
  return Padding(
    padding: EdgeInsets.all(5.wp),
    child: Column(
      children: [
        Row(
          children: [
            //image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.network(
                "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000",
              ),
            ),
            SizedBox(width: 2.wp),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      //content
                      Expanded(
                        child: Text(
                          "Music Festival : Presented by Yours Club",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 2.wp),
                      //button
                      Transform.rotate(
                        angle: -90 * 3.1415926535 / 180,
                        child: const Icon(Icons.arrow_outward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
