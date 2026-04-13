import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/trips/create_trip_header.dart';
import 'package:eventjar/page/budget_track/trips/trip_list.dart';
import 'package:flutter/material.dart';

class TripsTab extends StatelessWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
      children: [
        /// 🔥 Create Trip CTA
        const CreateTripCard(),

        SizedBox(height: 2.hp),

        /// Trips List
        const TripsList(),
      ],
    );
  }
}
