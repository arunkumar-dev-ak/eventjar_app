import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/trips/trip_card.dart';
import 'package:flutter/material.dart';

class TripsList extends StatelessWidget {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = [
      {
        "title": "Goa Trip",
        "location": "Goa, India",
        "members": 4,
        "budget": 20000,
        "spent": 13500,
      },
      {
        "title": "Manali Ride",
        "location": "Manali, Himachal",
        "members": 6,
        "budget": 30000,
        "spent": 22000,
      },
      {
        "title": "Chennai Meetup",
        "location": "Chennai",
        "members": 3,
        "budget": 8000,
        "spent": 5000,
      },
      {
        "title": "Goa Trip",
        "location": "Goa, India",
        "members": 4,
        "budget": 20000,
        "spent": 13500,
      },
      {
        "title": "Manali Ride",
        "location": "Manali, Himachal",
        "members": 6,
        "budget": 30000,
        "spent": 22000,
      },
      {
        "title": "Chennai Meetup",
        "location": "Chennai",
        "members": 3,
        "budget": 8000,
        "spent": 5000,
      },
      {
        "title": "Goa Trip",
        "location": "Goa, India",
        "members": 4,
        "budget": 20000,
        "spent": 13500,
      },
      {
        "title": "Manali Ride",
        "location": "Manali, Himachal",
        "members": 6,
        "budget": 30000,
        "spent": 22000,
      },
      {
        "title": "Chennai Meetup",
        "location": "Chennai",
        "members": 3,
        "budget": 8000,
        "spent": 5000,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trips.length,
      padding: EdgeInsets.only(bottom: 2.hp),
      itemBuilder: (_, index) {
        final trip = trips[index];
        return TripCard(
          index: index,
          title: trip["title"] as String,
          location: trip["location"] as String,
          members: trip["members"] as int,
          budget: trip["budget"] as int,
          spent: trip["spent"] as int,
        );
      },
    );
  }
}
