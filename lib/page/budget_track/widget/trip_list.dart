import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/page/budget_track/active_widget/active_trip_card.dart';
import 'package:eventjar/page/budget_track/inactive_widget/inactive_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripsList extends GetView<BudgetTrackController> {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = dummyTrips;

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final currentTrip = trips[index];

        if (currentTrip.isActive) {
          return GestureDetector(
            onTap: () {
              controller.navigateToViewTrip(currentTrip);
            },
            child: ActiveTripCard(index: index, trip: currentTrip),
          );
        }

        return GestureDetector(
          onTap: () {
            controller.navigateToViewTrip(currentTrip);
          },
          child: InactiveTripCard(index: index, trip: currentTrip),
        );
      },
    );
  }
}
