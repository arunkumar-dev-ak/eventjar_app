import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/empty_widget.dart';
import 'package:eventjar/page/budget_track/active_widget/active_trip_card.dart';
import 'package:eventjar/page/budget_track/inactive_widget/inactive_trip_card.dart';
import 'package:eventjar/page/budget_track/widget/trip_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripsList extends GetView<BudgetTrackController> {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Initial Loading
      if (controller.state.isLoading.value) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (_, __) => const TripCardShimmer(),
        );
      }

      // Empty State
      if (controller.state.trips.isEmpty) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 60.hp,
            child: EmptyStateWidget(
              icon: Icons.luggage_rounded,
              title: 'no_trips_yet'.tr,
              subtitle: 'create_trip_track_expenses'.tr,
            ),
          ),
        );
      }

      final haveNextPage =
          controller.state.meta.value?.paging.links.next != null ? true : false;

      return ListView.builder(
        controller: controller.tripScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: haveNextPage
            ? controller.state.trips.length + 1
            : controller.state.trips.length,
        itemBuilder: (context, index) {
          if (index >= controller.state.trips.length) {
            return const TripCardShimmer();
          }

          final trip = controller.state.trips[index];

          final isActiveTrip = index == 0;

          return GestureDetector(
            onTap: () {
              controller.navigateToViewTrip(trip);
            },
            child: isActiveTrip
                ? ActiveTripCard(index: index, trip: trip)
                : InactiveTripCard(index: index, trip: trip),
          );
        },
      );
    });
  }
}
