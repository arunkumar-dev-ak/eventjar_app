import 'package:eventjar_app/controller/home/controller.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void openSearchModel(BuildContext context) {
  final HomeController controller = Get.find();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel", style: TextStyle(fontSize: 11.sp)),
                    ),
                    Text(
                      "Search Event",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Search", style: TextStyle(fontSize: 11.sp)),
                    ),
                  ],
                ),
              ),
              homeSearchModel(controller),
              SizedBox(height: 2.hp),
              Expanded(
                child: SingleChildScrollView(
                  child: homeSearchContent(controller),
                ),
              ),
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
    child: Obx(() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(Icons.search, size: 22, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller.searchBarController,
                decoration: InputDecoration(
                  hintText: 'Search by event name, type or location',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10.sp,
                  ),
                ),
                onChanged: (val) => controller.handleSearchOnChnage(val),
              ),
            ),
            if (!controller.state.isSearchEmpty.value)
              GestureDetector(
                onTap: () => {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(
                      Icons.clear,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }),
  );
}

Widget homeSearchContent(HomeController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 1.hp),
    child: Column(
      children: List.generate(5, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.hp),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?ixlib=rb-4.1.0&q=60&w=300",
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Music Festival: Presented by Yours Club",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.5.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      "Starts at 7 PM · Downtown Arena",
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        );
      }),
    ),
  );
}
