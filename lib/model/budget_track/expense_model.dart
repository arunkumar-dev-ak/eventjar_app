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

List<ExpenseModel> dummyExpenses = [
  ExpenseModel(
    title: "Dinner at Beach",
    paidBy: "Arun",
    amount: 2200,
    yourShare: 550,
    date: DateTime.now(),
    icon: Icons.restaurant,
    color: Colors.orange,
  ),
  ExpenseModel(
    title: "Taxi to Anjuna",
    paidBy: "Rahul",
    amount: 800,
    yourShare: 200,
    date: DateTime.now(),
    icon: Icons.local_taxi,
    color: Colors.yellow.shade700,
  ),
  ExpenseModel(
    title: "Sunset Drinks",
    paidBy: "You",
    amount: 1500,
    yourShare: 375,
    date: DateTime.now(),
    icon: Icons.local_bar,
    color: Colors.purple,
  ),
  ExpenseModel(
    title: "Scuba Booking",
    paidBy: "Kiran",
    amount: 5000,
    yourShare: 1250,
    date: DateTime.now().subtract(const Duration(days: 1)),
    icon: Icons.scuba_diving,
    color: Colors.blue,
  ),
  ExpenseModel(
    title: "Breakfast Cafe",
    paidBy: "Arun",
    amount: 900,
    yourShare: 225,
    date: DateTime.now().subtract(const Duration(days: 1)),
    icon: Icons.free_breakfast,
    color: Colors.brown,
  ),

  /// 🔽 older dates
  ...List.generate(15, (i) {
    return ExpenseModel(
      title: "Expense ${i + 1}",
      paidBy: i % 2 == 0 ? "You" : "Rahul",
      amount: 500 + (i * 100),
      yourShare: 100 + (i * 20),
      date: DateTime.now().subtract(Duration(days: 2 + (i ~/ 3))),
      icon: Icons.receipt_long,
      color: Colors.teal,
    );
  }),
];
