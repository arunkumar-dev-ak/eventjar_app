import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/friends/friend_card.dart';
import 'package:flutter/material.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    /// MOCK DATA
    final friends = [
      {"name": "Arun Kumar", "email": "arun@gmail.com"},
      {"name": "John Doe", "email": "john@gmail.com"},
      {"name": "Priya Sharma", "email": "priya@gmail.com"},
      {"name": "Arun Kumar", "email": "arun@gmail.com"},
      {"name": "John Doe", "email": "john@gmail.com"},
      {"name": "Priya Sharma", "email": "priya@gmail.com"},
      {"name": "Arun Kumar", "email": "arun@gmail.com"},
      {"name": "John Doe", "email": "john@gmail.com"},
      {"name": "Priya Sharma", "email": "priya@gmail.com"},
      {"name": "Arun Kumar", "email": "arun@gmail.com"},
      {"name": "John Doe", "email": "john@gmail.com"},
      {"name": "Priya Sharma", "email": "priya@gmail.com"},
    ];

    return ListView.separated(
      itemCount: friends.length,
      separatorBuilder: (_, __) => SizedBox(height: 2.hp),
      itemBuilder: (_, index) {
        return FriendCard(
          name: friends[index]["name"]!,
          email: friends[index]["email"]!,
        );
      },
    );
  }
}
