import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/widget/trip_list.dart';
import 'package:flutter/material.dart';

class TripsTab extends StatelessWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
      children: [
        /// Trips List
        const TripsList(),
      ],
    );
  }
}
