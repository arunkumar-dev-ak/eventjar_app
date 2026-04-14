class TransactionModel {
  final String name;
  final String subtitle;
  final String date; // "14 April"
  final int amount;
  final bool isReceived;
  final String month; // "April"
  final String year; // "2026"

  TransactionModel({
    required this.name,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isReceived,
    required this.month,
    required this.year,
  });
}
