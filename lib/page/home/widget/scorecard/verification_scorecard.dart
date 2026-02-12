import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/home/widget/scorecard/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildVerificationScoreCard() {
  final HomeController controller = Get.find<HomeController>();

  final pages = scorecardBuildVerificationPages();
  if (pages.isEmpty) return const SizedBox.shrink();

  final int totalPages = pages.length;
  final int currentPage = controller.scoreCardCurrentPage.clamp(
    0,
    totalPages - 1,
  );

  return Container(
    width: double.infinity,
    height: 9.hp,
    decoration: _scoreCardDecoration(),
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                onTap: currentPage > 0
                    ? () {
                        controller.scoreCardPageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                child: Container(
                  width: 7.wp,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: currentPage > 0
                      ? Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 5.wp,
                        )
                      : SizedBox(width: 5.wp),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.scoreCardPageController,
                  onPageChanged: (index) {
                    controller.state.scoreCardCurrentPage.value = index;
                    controller.resetAutoScrollTimer();
                  },
                  children: pages,
                ),
              ),
              GestureDetector(
                onTap: currentPage < totalPages - 1
                    ? () {
                        controller.scoreCardPageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                child: Container(
                  width: 7.wp,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: currentPage < totalPages - 1
                      ? Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 5.wp,
                        )
                      : SizedBox(width: 5.wp),
                ),
              ),
            ],
          ),
        ),
        if (totalPages > 1)
          Padding(
            padding: EdgeInsets.only(bottom: 0.7.hp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalPages,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 0.8.wp),
                  width: i == currentPage ? 4.wp : 1.5.wp,
                  height: 0.7.hp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: i == currentPage
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

BoxDecoration _scoreCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(14),
      bottomRight: Radius.circular(14),
    ),
    gradient: const LinearGradient(
      colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF1565C0).withValues(alpha: 0.5),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
