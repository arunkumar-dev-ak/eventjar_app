import 'package:flutter/material.dart';

class ExpenseModel {
  final String title;
  final String paidBy;
  final double amount;
  final double yourShare;
  final DateTime date;
  final IconData icon;
  final Color color;

  ExpenseModel({
    required this.title,
    required this.paidBy,
    required this.amount,
    required this.yourShare,
    required this.date,
    required this.icon,
    required this.color,
  });
}

final Map<String, List<ExpenseModel>> dummyTripExpenses = {
  "Goa Beach Escape": [
    /// Rahul final => YOU OWE 120
    ExpenseModel(
      title: "Taxi to Anjuna",
      paidBy: "Rahul",
      amount: 800,
      yourShare: 200,
      date: DateTime.now(),
      icon: Icons.local_taxi,
      color: Colors.amber,
    ),

    ExpenseModel(
      title: "Beach Snacks",
      paidBy: "Rahul",
      amount: 600,
      yourShare: 200,
      date: DateTime.now(),
      icon: Icons.fastfood,
      color: Colors.orange,
    ),

    ExpenseModel(
      title: "Sunset Drinks",
      paidBy: "You",
      amount: 800,
      yourShare: 200,
      date: DateTime.now(),
      icon: Icons.local_bar,
      color: Colors.purple,
    ),

    ExpenseModel(
      title: "Scooter Fuel",
      paidBy: "You",
      amount: 320,
      yourShare: 80,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.local_gas_station,
      color: Colors.blue,
    ),

    /// Arjun final => YOU RECEIVE 120
    ExpenseModel(
      title: "Beach Dinner",
      paidBy: "You",
      amount: 480,
      yourShare: 120,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.restaurant,
      color: Colors.red,
    ),
  ],

  "Ooty Chill Trip": [
    /// Vignesh => YOU OWE 180
    ExpenseModel(
      title: "Tea Estate Cab",
      paidBy: "Vignesh",
      amount: 540,
      yourShare: 180,
      date: DateTime.now(),
      icon: Icons.directions_car,
      color: Colors.green,
    ),

    /// Settled Dinesh
    ExpenseModel(
      title: "Homestay Breakfast",
      paidBy: "Dinesh",
      amount: 300,
      yourShare: 150,
      date: DateTime.now(),
      icon: Icons.free_breakfast,
      color: Colors.brown,
    ),

    ExpenseModel(
      title: "Botanical Garden",
      paidBy: "You",
      amount: 300,
      yourShare: 150,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.park,
      color: Colors.teal,
    ),
  ],

  "Chennai Meetup": [
    /// Sanjay => YOU RECEIVE 150
    ExpenseModel(
      title: "Dinner Buffet",
      paidBy: "You",
      amount: 300,
      yourShare: 150,
      date: DateTime.now(),
      icon: Icons.restaurant,
      color: Colors.deepOrange,
    ),

    ExpenseModel(
      title: "Movie Tickets",
      paidBy: "Sanjay",
      amount: 200,
      yourShare: 100,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.movie,
      color: Colors.indigo,
    ),
  ],

  "Bangalore Weekend": [
    /// Rahul => YOU OWE 220
    ExpenseModel(
      title: "Metro Pass",
      paidBy: "Rahul",
      amount: 440,
      yourShare: 220,
      date: DateTime.now(),
      icon: Icons.train,
      color: Colors.blueGrey,
    ),

    /// Settled Arjun
    ExpenseModel(
      title: "Cafe Bill",
      paidBy: "Arjun",
      amount: 300,
      yourShare: 150,
      date: DateTime.now(),
      icon: Icons.coffee,
      color: Colors.brown,
    ),

    ExpenseModel(
      title: "Bowling",
      paidBy: "You",
      amount: 300,
      yourShare: 150,
      date: DateTime.now(),
      icon: Icons.sports_esports,
      color: Colors.purple,
    ),

    /// Settled Vignesh
    ExpenseModel(
      title: "Snacks",
      paidBy: "Vignesh",
      amount: 200,
      yourShare: 100,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.fastfood,
      color: Colors.orange,
    ),

    ExpenseModel(
      title: "Parking",
      paidBy: "You",
      amount: 200,
      yourShare: 100,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.local_parking,
      color: Colors.green,
    ),
  ],

  "Pondicherry Ride": [
    /// Sanjay => YOU RECEIVE 200
    ExpenseModel(
      title: "Beach Cafe",
      paidBy: "You",
      amount: 400,
      yourShare: 200,
      date: DateTime.now(),
      icon: Icons.restaurant,
      color: Colors.orange,
    ),

    /// Settled Karthik
    ExpenseModel(
      title: "Bike Fuel",
      paidBy: "Karthik",
      amount: 200,
      yourShare: 100,
      date: DateTime.now(),
      icon: Icons.local_gas_station,
      color: Colors.red,
    ),

    ExpenseModel(
      title: "Museum Entry",
      paidBy: "You",
      amount: 200,
      yourShare: 100,
      date: DateTime.now(),
      icon: Icons.museum,
      color: Colors.blue,
    ),
  ],

  "Kerala Backwaters": [
    /// Rahul => YOU OWE 150
    ExpenseModel(
      title: "Houseboat Advance",
      paidBy: "Rahul",
      amount: 600,
      yourShare: 150,
      date: DateTime.now(),
      icon: Icons.sailing,
      color: Colors.cyan,
    ),

    /// Vignesh => YOU OWE 200
    ExpenseModel(
      title: "Lunch Meals",
      paidBy: "Vignesh",
      amount: 800,
      yourShare: 200,
      date: DateTime.now(),
      icon: Icons.lunch_dining,
      color: Colors.orange,
    ),

    /// Settled Arjun
    ExpenseModel(
      title: "Tea Shop",
      paidBy: "Arjun",
      amount: 200,
      yourShare: 100,
      date: DateTime.now(),
      icon: Icons.emoji_food_beverage,
      color: Colors.brown,
    ),

    ExpenseModel(
      title: "Boat Snacks",
      paidBy: "You",
      amount: 200,
      yourShare: 100,
      date: DateTime.now(),
      icon: Icons.fastfood,
      color: Colors.green,
    ),
  ],

  "Hyderabad Food Tour": [
    /// Rahul => YOU OWE 240
    ExpenseModel(
      title: "Biryani Dinner",
      paidBy: "Rahul",
      amount: 960,
      yourShare: 240,
      date: DateTime.now(),
      icon: Icons.restaurant,
      color: Colors.deepOrange,
    ),

    /// Sanjay => YOU RECEIVE 80
    ExpenseModel(
      title: "Cafe Dessert",
      paidBy: "You",
      amount: 320,
      yourShare: 80,
      date: DateTime.now(),
      icon: Icons.cake,
      color: Colors.pink,
    ),

    /// Settled Dinesh
    ExpenseModel(
      title: "Juice Shop",
      paidBy: "Dinesh",
      amount: 160,
      yourShare: 80,
      date: DateTime.now(),
      icon: Icons.local_drink,
      color: Colors.green,
    ),

    ExpenseModel(
      title: "Late Night Tea",
      paidBy: "You",
      amount: 160,
      yourShare: 80,
      date: DateTime.now(),
      icon: Icons.emoji_food_beverage,
      color: Colors.brown,
    ),
  ],

  "Coorg Nature Stay": [
    /// Arjun => YOU RECEIVE 170
    ExpenseModel(
      title: "Resort Booking",
      paidBy: "You",
      amount: 510,
      yourShare: 170,
      date: DateTime.now(),
      icon: Icons.hotel,
      color: Colors.indigo,
    ),

    /// Settled Karthik
    ExpenseModel(
      title: "Coffee Estate Entry",
      paidBy: "Karthik",
      amount: 200,
      yourShare: 100,
      date: DateTime.now(),
      icon: Icons.park,
      color: Colors.green,
    ),

    ExpenseModel(
      title: "Campfire Snacks",
      paidBy: "You",
      amount: 200,
      yourShare: 100,
      date: DateTime.now(),
      icon: Icons.local_fire_department,
      color: Colors.orange,
    ),
  ],
};
