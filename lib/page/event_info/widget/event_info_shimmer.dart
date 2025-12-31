import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eventjar/global/responsive/responsive.dart';

class EventInfoHeaderShimmer extends StatelessWidget {
  const EventInfoHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel Image Section (25hp matching your appbar)
          Container(
            height: 25.hp,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Main image shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  period: const Duration(milliseconds: 1500),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),

                // Gradient overlay shimmer effect
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withValues(alpha: 0.6),
                          Colors.transparent,
                          Colors.grey.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Mode badge shimmer - top left
                Positioned(
                  top: 12,
                  left: 12,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.7),
                    highlightColor: Colors.white,
                    period: const Duration(milliseconds: 1200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                // Price badge shimmer - top right
                Positioned(
                  top: 12,
                  right: 12,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.7),
                    highlightColor: Colors.white,
                    period: const Duration(milliseconds: 1200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                // Stats shimmer - bottom left (like your appbar)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.8),
                    highlightColor: Colors.white,
                    period: const Duration(milliseconds: 1000),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 60,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 50,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.hp),

          // Quick Info Row shimmer (matching your existing design)
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade400,
            period: const Duration(milliseconds: 1500),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Date & Time section
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(width: 3.wp),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 14,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 10,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  SizedBox(width: 4.wp),
                  // Location section
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(width: 3.wp),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 14,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 10,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventInfoEventNameShimmer extends StatelessWidget {
  const EventInfoEventNameShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade300,
        period: const Duration(milliseconds: 1500),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventInfoTabBarShimmer extends StatelessWidget {
  const EventInfoTabBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      period: const Duration(milliseconds: 1200),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp),
        child: Column(
          children: [
            Row(
              children: List.generate(6, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: index < 5 ? 12 : 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Active tab (leftmost)
                      if (index == 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 40,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Inactive tabs
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 0.5.hp),
            // Tab underline shimmer
            Container(
              height: 1,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventInfoTabContentShimmer extends StatelessWidget {
  const EventInfoTabContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      period: const Duration(milliseconds: 1500),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(4.wp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 2.hp),

            // Content blocks (3-4 cards)
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 2.hp),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.wp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card header
                      Container(
                        height: 14,
                        width: index == 0 ? 120 : 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      SizedBox(height: 1.5.hp),

                      // Content rows
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          SizedBox(width: 3.wp),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 12,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                SizedBox(height: 0.5.hp),
                                Container(
                                  height: 10,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
